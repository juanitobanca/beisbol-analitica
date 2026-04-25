"""
agg_pitching_balls_in_play_heatmaps_sqlite.py
─────────────────────────────────────────────
Equivalent of the MySQL CALL agg_pitching_balls_in_play_heatmaps(...) cube inserts,
rewritten as static SQL for SQLite3.

Key differences from the batting_stats scripts:
  - Target table  : agg_pitching_balls_in_play_heatmaps
  - Source table  : game_player_balls_in_play_heatmaps
  - No officials  : CTE has no game_officials join
  - Stat columns  : HM4 (4 quadrants) + HM8 (8 octants) heatmap fields

groupingId   → SHA-256 of sorted field names (first 8 hex digits as int)
groupingDesc → field names uppercased, joined by '_'

Usage:
    python agg_pitching_balls_in_play_heatmaps_sqlite.py [--output agg_pitching_balls_in_play_heatmaps.sql]
"""

import argparse
import hashlib

# ── All possible dimension columns (order = INSERT column order) ─────────────
ALL_DIMS = [
    "majorLeagueId",
    "seasonId",
    "gameType2",
    "teamId",
    "teamType",
    "playerId",
    "venueId",
]

# ── Groupings — direct translation of each CALL ──────────────────────────────
GROUPINGS = [
    {"fields": ["majorLeagueId", "seasonId", "gameType2"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "teamType", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "teamType"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamId", "teamType"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamType"]},
]

# ── Stat columns (order matches INSERT target table) ─────────────────────────
# 'games' is handled separately via COUNT(DISTINCT gamePk)
HM4_ZONES   = ["RF1", "RF2", "LF1", "LF2"]
HM8_ZONES   = ["RF1", "RF2", "RF3", "RF4", "LF1", "LF2", "LF3", "LF4"]
HIT_TYPES   = ["X1B", "X2B", "X3B", "HR", "H"]
BALL_TYPES  = ["FB", "GB", "LD", "PU", "GBNT", "PUB", "LDB"]

def _hm4_cols() -> list[str]:
    cols = ["HM4_RF1", "HM4_RF2", "HM4_LF1", "HM4_LF2", "HM4_FHP", "HM4_FLF", "HM4_FRF"]
    for zone in HM4_ZONES:
        cols += [f"HM4_{zone}_{h}" for h in HIT_TYPES]
    for zone in HM4_ZONES:
        cols += [f"HM4_{zone}_{b}" for b in BALL_TYPES]
    return cols

def _hm8_cols() -> list[str]:
    cols  = [f"HM8_{z}" for z in HM8_ZONES]
    cols += ["HM8_FHP", "HM8_FLF", "HM8_FRF"]
    for zone in HM8_ZONES:
        cols += [f"HM8_{zone}_{h}" for h in HIT_TYPES]
    for zone in HM8_ZONES:
        cols += [f"HM8_{zone}_{b}" for b in BALL_TYPES]
    return cols

STAT_COLS = ["games"] + _hm4_cols() + _hm8_cols()


def grouping_id(fields: list[str]) -> int:
    """Stable integer ID: SHA-256 of sorted field names, first 8 hex digits as uint."""
    key = ",".join(sorted(fields))
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def grouping_desc(fields: list[str]) -> str:
    """e.g. ["majorLeagueId", "seasonId"] → "MAJORLEAGUEID_SEASONID" """
    return "_".join(f.upper() for f in fields)


def build_cte() -> str:
    """CTEs shared by every grouping query. No officials join for this procedure."""
    return """
WITH bs AS (
    SELECT * FROM game_player_balls_in_play_heatmaps
),
g AS (
    SELECT majorLeagueId, seasonId, gamePk, gameType2, venueId, homeTeamId
    FROM games
    WHERE gameType2 IN ('PS', 'RS')
),
data AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gamePk, g.gameType2, g.venueId,
        CASE WHEN g.homeTeamId = bs.pitchingTeamId THEN 'home' ELSE 'away' END AS teamType,
        bs.pitchingTeamId AS teamId,
        bs.pitcherId      AS playerId,
        batSide, pitchHand, menOnBase,
        HM4_RF1, HM4_RF2, HM4_LF1, HM4_LF2, HM4_FHP, HM4_FLF, HM4_FRF,
        HM4_LF1_X1B, HM4_LF1_X2B, HM4_LF1_X3B, HM4_LF1_HR, HM4_LF1_H,
        HM4_LF2_X1B, HM4_LF2_X2B, HM4_LF2_X3B, HM4_LF2_HR, HM4_LF2_H,
        HM4_RF1_X1B, HM4_RF1_X2B, HM4_RF1_X3B, HM4_RF1_HR, HM4_RF1_H,
        HM4_RF2_X1B, HM4_RF2_X2B, HM4_RF2_X3B, HM4_RF2_HR, HM4_RF2_H,
        HM4_RF1_FB, HM4_RF1_GB, HM4_RF1_LD, HM4_RF1_PU, HM4_RF1_GBNT, HM4_RF1_PUB, HM4_RF1_LDB,
        HM4_RF2_FB, HM4_RF2_GB, HM4_RF2_LD, HM4_RF2_PU, HM4_RF2_GBNT, HM4_RF2_PUB, HM4_RF2_LDB,
        HM4_LF1_FB, HM4_LF1_GB, HM4_LF1_LD, HM4_LF1_PU, HM4_LF1_GBNT, HM4_LF1_PUB, HM4_LF1_LDB,
        HM4_LF2_FB, HM4_LF2_GB, HM4_LF2_LD, HM4_LF2_PU, HM4_LF2_GBNT, HM4_LF2_PUB, HM4_LF2_LDB,
        HM8_RF1, HM8_RF2, HM8_RF3, HM8_RF4, HM8_LF1, HM8_LF2, HM8_LF3, HM8_LF4,
        HM8_FHP, HM8_FLF, HM8_FRF,
        HM8_LF1_X1B, HM8_LF1_X2B, HM8_LF1_X3B, HM8_LF1_HR, HM8_LF1_H,
        HM8_LF2_X1B, HM8_LF2_X2B, HM8_LF2_X3B, HM8_LF2_HR, HM8_LF2_H,
        HM8_LF3_X1B, HM8_LF3_X2B, HM8_LF3_X3B, HM8_LF3_HR, HM8_LF3_H,
        HM8_LF4_X1B, HM8_LF4_X2B, HM8_LF4_X3B, HM8_LF4_HR, HM8_LF4_H,
        HM8_RF1_X1B, HM8_RF1_X2B, HM8_RF1_X3B, HM8_RF1_HR, HM8_RF1_H,
        HM8_RF2_X1B, HM8_RF2_X2B, HM8_RF2_X3B, HM8_RF2_HR, HM8_RF2_H,
        HM8_RF3_X1B, HM8_RF3_X2B, HM8_RF3_X3B, HM8_RF3_HR, HM8_RF3_H,
        HM8_RF4_X1B, HM8_RF4_X2B, HM8_RF4_X3B, HM8_RF4_HR, HM8_RF4_H,
        HM8_RF1_FB, HM8_RF1_GB, HM8_RF1_LD, HM8_RF1_PU, HM8_RF1_GBNT, HM8_RF1_PUB, HM8_RF1_LDB,
        HM8_RF2_FB, HM8_RF2_GB, HM8_RF2_LD, HM8_RF2_PU, HM8_RF2_GBNT, HM8_RF2_PUB, HM8_RF2_LDB,
        HM8_RF3_FB, HM8_RF3_GB, HM8_RF3_LD, HM8_RF3_PU, HM8_RF3_GBNT, HM8_RF3_PUB, HM8_RF3_LDB,
        HM8_RF4_FB, HM8_RF4_GB, HM8_RF4_LD, HM8_RF4_PU, HM8_RF4_GBNT, HM8_RF4_PUB, HM8_RF4_LDB,
        HM8_LF1_FB, HM8_LF1_GB, HM8_LF1_LD, HM8_LF1_PU, HM8_LF1_GBNT, HM8_LF1_PUB, HM8_LF1_LDB,
        HM8_LF2_FB, HM8_LF2_GB, HM8_LF2_LD, HM8_LF2_PU, HM8_LF2_GBNT, HM8_LF2_PUB, HM8_LF2_LDB,
        HM8_LF3_FB, HM8_LF3_GB, HM8_LF3_LD, HM8_LF3_PU, HM8_LF3_GBNT, HM8_LF3_PUB, HM8_LF3_LDB,
        HM8_LF4_FB, HM8_LF4_GB, HM8_LF4_LD, HM8_LF4_PU, HM8_LF4_GBNT, HM8_LF4_PUB, HM8_LF4_LDB
    FROM g
    INNER JOIN bs ON g.gamePk = bs.gamePk
)
"""


def build_select_exprs(active_fields: list[str]) -> list[str]:
    """
    Dimension columns: active → pass through, inactive → NULL.
    Stat columns: games → COUNT(DISTINCT gamePk), everything else → SUM().
    """
    dim_exprs = [
        col if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]

    stat_exprs = ["COUNT(DISTINCT gamePk) AS games"]
    for col in STAT_COLS:
        if col == "games":
            continue
        stat_exprs.append(f"SUM({col}) AS {col}")

    return dim_exprs + stat_exprs


def build_insert(grouping: dict) -> str:
    """Build the full INSERT … SELECT statement for one grouping."""
    active = grouping["fields"]
    gid    = grouping_id(active)
    gdesc  = grouping_desc(active)

    all_target_cols = ALL_DIMS + STAT_COLS + ["groupingId", "groupingDescription"]
    select_exprs    = build_select_exprs(active)
    group_by        = ", ".join(active)

    cols_str    = ",\n        ".join(all_target_cols)
    selects_str = ",\n        ".join(select_exprs)

    return f"""
-- ── Grouping {gid}: {gdesc} ──────────────────────────────────────────────
INSERT INTO agg_pitching_balls_in_play_heatmaps (
        {cols_str}
)
{build_cte().strip()}
SELECT
        {selects_str},
        {gid}     AS groupingId,
        '{gdesc}' AS groupingDescription
FROM data
GROUP BY {group_by};
"""


def generate_sql_file(output_path: str) -> None:
    header = """\
-- ============================================================
-- agg_pitching_balls_in_play_heatmaps cube — SQLite3 static equivalent
-- Generated by agg_pitching_balls_in_play_heatmaps_sqlite.py
-- Run with:  sqlite3 your_base.db < agg_pitching_balls_in_play_heatmaps.sql
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
        description="Generate agg_pitching_balls_in_play_heatmaps cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="../pitching/procedimientos/agg_pitching_balls_in_play_heatmaps.sql",
        help="Output .sql file path",
    )
    args = parser.parse_args()
    generate_sql_file(args.output)
