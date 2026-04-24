"""
agg_fielding_stats_sqlite.py
─────────────────────────────
Equivalent of the MySQL CALL agg_fielding_stats(...) cube inserts,
rewritten as static SQL for SQLite3.

Key differences from the batting scripts:
  - Target table  : agg_fielding_stats
  - Sources       : games + fielding_credits + atbats + game_player_fielding_outs
  - Extra dim     : positionAbbrev
  - Stat columns  : assists, catcherInterferences, errors, games,
                    putOuts, totalChances, outsPlayed
  - Extra column  : aggregationType (always 'AGGREGATED')
  - Two-level agg : inner CTE 'd' groups once, outer SELECT sums again
                    (mirrors the original procedure exactly)

groupingId   → SHA-256 of sorted field names (first 8 hex digits as int)
groupingDesc → field names uppercased, joined by '_'

Usage:
    python agg_fielding_stats_sqlite.py [--output agg_fielding_stats.sql]
"""

import argparse
import hashlib

# ── All possible dimension columns (order = INSERT column order) ─────────────
ALL_DIMS = [
    "majorLeagueId",
    "seasonId",
    "gameType2",
    "positionAbbrev",
    "teamId",
    "teamType",
    "playerId",
    "venueId",
]

# ── Groupings — direct translation of each CALL ──────────────────────────────
GROUPINGS = [
    {"fields": ["majorLeagueId", "seasonId", "gameType2"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "positionAbbrev", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "positionAbbrev", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamId", "teamType"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "teamType"]},
]

# ── Stat columns (order matches INSERT target table) ─────────────────────────
STAT_COLS = [
    "assists",
    "catcherInterferences",
    "errors",
    "games",
    "putOuts",
    "totalChances",
    "outsPlayed",
]


def grouping_id(fields: list[str]) -> int:
    """Stable integer ID: SHA-256 of sorted field names, first 8 hex digits as uint."""
    key = ",".join(sorted(fields))
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def grouping_desc(fields: list[str]) -> str:
    """e.g. ["majorLeagueId", "seasonId"] → "MAJORLEAGUEID_SEASONID" """
    return "_".join(f.upper() for f in fields)


def build_cte(active_fields: list[str]) -> str:
    """
    Full CTE block. The inner 'd' CTE groups by the active fields,
    mirroring the original procedure's two-level aggregation.
    """
    group_by = ", ".join(active_fields)

    # Dimension expressions inside the 'd' CTE:
    # active fields pass through from 'stats', inactive ones are NULL.
    dim_exprs_inner = [
        f"s.{col}" if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]
    dim_select_inner = ",\n        ".join(dim_exprs_inner)

    return f"""
WITH stats AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gameDate, g.gameType2, g.venueId,
        fc.positionAbbrev,
        CASE WHEN a.halfInning = 'top' THEN 'home' ELSE 'away' END AS teamType,
        CASE WHEN a.halfInning = 'top' THEN g.homeTeamId ELSE g.awayTeamId END AS teamId,
        g.gamePk,
        fc.playerId,
        CASE WHEN fc.credit LIKE '%assist%'          THEN 1 ELSE 0 END AS assists,
        CASE WHEN fc.credit = 'c_catcher_interf'     THEN 1 ELSE 0 END AS catcherInterferences,
        CASE WHEN fc.credit LIKE '%error%'            THEN 1 ELSE 0 END AS errors,
        CASE WHEN fc.credit = 'f_putout'             THEN 1 ELSE 0 END AS putOuts
    FROM games g
    INNER JOIN fielding_credits fc ON g.gamePk = fc.gamePk
    INNER JOIN atbats a
        ON fc.gamePk    = a.gamePk
        AND fc.atBatIndex = a.atBatIndex
    WHERE g.gameType2 IN ('PS', 'RS')
),
outs AS (
    SELECT gamePk AS outsGamePk, playerId AS outsPlayerId,
           positionAbbrev AS outsPositionAbbrev, outs
    FROM game_player_fielding_outs
),
d AS (
    SELECT
        {dim_select_inner},
        SUM(s.assists)                                                    AS assists,
        SUM(s.catcherInterferences)                                       AS catcherInterferences,
        SUM(s.errors)                                                     AS errors,
        COUNT(DISTINCT s.gamePk)                                          AS games,
        SUM(s.putOuts)                                                    AS putOuts,
        SUM(s.assists + s.catcherInterferences + s.errors + s.putOuts)    AS totalChances,
        SUM(o.outs)                                                       AS outsPlayed
    FROM stats s
    INNER JOIN outs o
        ON  s.gamePk        = o.outsGamePk
        AND s.playerId      = o.outsPlayerId
        AND s.positionAbbrev = o.outsPositionAbbrev
    GROUP BY {group_by}
)"""


def build_select_exprs(active_fields: list[str]) -> list[str]:
    """
    Dimension columns: active → pass through from 'd', inactive → NULL.
    Stat columns: all plain SUM() over the already-grouped 'd' CTE.
    """
    dim_exprs = [
        col if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]

    stat_exprs = [
        "SUM(assists)              AS assists",
        "SUM(catcherInterferences) AS catcherInterferences",
        "SUM(errors)               AS errors",
        "SUM(games)                AS games",
        "SUM(putOuts)              AS putOuts",
        "SUM(totalChances)         AS totalChances",
        "SUM(outsPlayed)           AS outsPlayed",
    ]

    return dim_exprs + stat_exprs


def build_insert(grouping: dict) -> str:
    """Build the full INSERT … SELECT statement for one grouping."""
    active = grouping["fields"]
    gid    = grouping_id(active)
    gdesc  = grouping_desc(active)

    all_target_cols = ALL_DIMS + ["aggregationType"] + STAT_COLS + ["groupingId", "groupingDescription"]
    select_exprs    = build_select_exprs(active)
    group_by        = ", ".join(active)

    cols_str    = ",\n        ".join(all_target_cols)
    selects_str = ",\n        ".join(select_exprs)

    return f"""
-- ── Grouping {gid}: {gdesc} ──────────────────────────────────────────────
INSERT INTO agg_fielding_stats (
        {cols_str}
)
{build_cte(active).strip()}
SELECT
        {selects_str},
        'AGGREGATED' AS aggregationType,
        {gid}        AS groupingId,
        '{gdesc}'    AS groupingDescription
FROM d
GROUP BY {group_by};
"""


def generate_sql_file(output_path: str) -> None:
    header = """\
-- ============================================================
-- agg_fielding_stats cube — SQLite3 static equivalent
-- Generated by agg_fielding_stats_sqlite.py
-- Run with:  sqlite3 your_base.db < agg_fielding_stats.sql
-- ============================================================

BEGIN;
"""
    footer = "\nCOMMIT;\n"

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(header)
        for grouping in GROUPINGS:
            f.write(build_insert(grouping))
            f.write("\n")
        f.write(footer)

    print(f"✓ SQL file written to: {output_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate agg_fielding_stats cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="agg_fielding_stats.sql",
        help="Output .sql file path (default: agg_fielding_stats.sql)",
    )
    args = parser.parse_args()
    generate_sql_file(args.output)
