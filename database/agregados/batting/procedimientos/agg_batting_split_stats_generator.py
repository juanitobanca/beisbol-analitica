"""
agg_batting_split_stats_sqlite.py
───────────────────────────────────
Equivalent of the MySQL CALL agg_batting_split_stats(...) cube inserts,
rewritten as static SQL for SQLite3.

Differences from agg_batting_stats:
  - Target table : agg_batting_split_stats
  - Extra dims   : batSide, pitchHand, menOnBase (the "split" dimensions)
  - Groupings    : driven by the original CALL sequence

groupingId   → SHA-256 of sorted field names (first 8 hex digits as int)
groupingDesc → field names uppercased, joined by '_'

Usage:
    python agg_batting_split_stats_sqlite.py [--output agg_batting_split_stats.sql]
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
    "officialId",
    "opposingTeamId",
    # split dimensions
    "batSide",
    "pitchHand",
    "menOnBase",
]

# ── Groupings — direct translation of each CALL ──────────────────────────────
GROUPINGS = [
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "batSide"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "menOnBase"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "playerId", "batSide"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "playerId", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "playerId", "menOnBase"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "batSide"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "menOnBase"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId", "batSide"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "batSide", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamId", "teamType", "batSide"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamId", "teamType", "pitchHand"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "officialId", "batSide"]},
]

# ── Stat columns (order matches INSERT target table) ─────────────────────────
STAT_COLS = [
    "atbats", "balks", "batterInterferences", "bunts", "catcherInterferences",
    "doubles", "fanInterferences", "fieldErrors", "fieldersChoice", "flyouts",
    "forceOuts", "games", "groundedIntoDoublePlays", "groundedIntoTriplePlays",
    "groundOuts", "hitByPitch", "hits", "homeRuns", "intentionalWalks",
    "lineOuts", "passedBalls", "popOuts", "runsBattedIn", "sacBunts", "sacFlies",
    "singles", "strikeOuts", "triples", "walks", "wildPitches",
    # pitch metrics
    "balls", "ballsPitchOut", "ballsInDirt", "intentBalls", "fouls", "foulBunts",
    "foulTips", "foulPitchOuts", "hitIntoPlay", "pitches", "pitchOuts", "strikes",
    "strikesCalled", "strikesPitchOuts", "missedBunts", "swingAndMissStrikes",
    "swingsPitchOuts", "swings",
    "swingsZeroAndZero", "swingsZeroAndOne", "swingsZeroAndTwo",
    "swingsOneAndZero",  "swingsOneAndOne",  "swingsOneAndTwo",
    "swingsTwoAndZero",  "swingsTwoAndOne",  "swingsTwoAndTwo",
    "swingsThreeAndZero","swingsThreeAndOne", "swingsThreeAndTwo",
    "flyBalls", "groundBalls", "lineDrives", "popUps",
    "groundBunts", "popupBunts", "lineDriveBunts",
]


def grouping_id(fields: list[str]) -> int:
    """
    Stable integer ID derived from SHA-256 of the sorted, comma-joined field names.
    Takes the first 8 hex digits (32 bits) as an unsigned integer.
    """
    key = ",".join(sorted(fields))
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def grouping_desc(fields: list[str]) -> str:
    """
    e.g. ["majorLeagueId", "seasonId", "batSide"] → "MAJORLEAGUEID_SEASONID_BATSIDE"
    """
    return "_".join(f.upper() for f in fields)


def build_cte() -> str:
    """Common Table Expressions shared by every grouping query."""
    return """
WITH bs AS (
    SELECT *, pitchingTeamId AS opposingTeamId
    FROM game_player_split_stats
),
g AS (
    SELECT majorLeagueId, seasonId, gamePk, gameType2, venueId, homeTeamId
    FROM games
    WHERE gameType2 IN ('PS', 'RS')
),
officials AS (
    SELECT gamePk, officialId
    FROM game_officials
    WHERE position = 'Home Plate'
),
data AS (
    SELECT
        g.majorLeagueId, g.seasonId, g.gamePk, g.gameType2, g.venueId,
        CASE WHEN g.homeTeamId = bs.battingTeamId THEN 'home' ELSE 'away' END AS teamType,
        bs.battingTeamId  AS teamId,
        bs.batterId       AS playerId,
        bs.opposingTeamId,
        o.officialId,
        batSide, pitchHand, menOnBase,
        (batterInterferences + bunts + doubles + fanInterferences + fieldErrors
         + fieldersChoice + flyouts + forceOuts + groundedIntoDoublePlays
         + triplePlays + groundOuts + homeRuns + lineOuts + popOuts
         + singles + strikeOuts + triples) AS atbats,
        balks, batterInterferences, bunts, catcherInterferences, doubles,
        fanInterferences, fieldErrors, fieldersChoice, flyouts, forceOuts,
        groundedIntoDoublePlays, groundOuts, hitByPitch, homeRuns,
        intentionalWalks, lineOuts, passedBalls, popOuts, runsBattedIn,
        sacBunts, sacFlies, singles, strikeOuts, triples, triplePlays,
        walks, wildPitches,
        balls, ballsPitchOut, ballsInDirt, intentBalls, fouls, foulBunts,
        foulTips, foulPitchOuts, hitIntoPlay, pitches, pitchOuts, strikes,
        strikesCalled, strikesPitchOuts, missedBunts, swingAndMissStrikes,
        swingsPitchOuts, swings,
        swingsZeroAndZero, swingsZeroAndOne, swingsZeroAndTwo,
        swingsOneAndZero,  swingsOneAndOne,  swingsOneAndTwo,
        swingsTwoAndZero,  swingsTwoAndOne,  swingsTwoAndTwo,
        swingsThreeAndZero,swingsThreeAndOne, swingsThreeAndTwo,
        flyBalls, groundBalls, lineDrives, popUps,
        groundBunts, popupBunts, lineDriveBunts
    FROM g
    INNER JOIN bs          ON g.gamePk = bs.gamePk
    LEFT  JOIN officials o ON g.gamePk = o.gamePk
)
"""


def build_select_exprs(active_fields: list[str]) -> list[str]:
    """
    For each dimension: SELECT the column if active, else NULL.
    Then append all aggregated stat expressions.
    """
    dim_exprs = [
        col if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]

    stat_exprs = [
        "SUM(atbats)                  AS atbats",
        "SUM(balks)                   AS balks",
        "SUM(batterInterferences)     AS batterInterferences",
        "SUM(bunts)                   AS bunts",
        "SUM(catcherInterferences)    AS catcherInterferences",
        "SUM(doubles)                 AS doubles",
        "SUM(fanInterferences)        AS fanInterferences",
        "SUM(fieldErrors)             AS fieldErrors",
        "SUM(fieldersChoice)          AS fieldersChoice",
        "SUM(flyouts)                 AS flyouts",
        "SUM(forceOuts)               AS forceOuts",
        "COUNT(DISTINCT gamePk)       AS games",
        "SUM(groundedIntoDoublePlays) AS groundedIntoDoublePlays",
        "SUM(triplePlays)             AS groundedIntoTriplePlays",
        "SUM(groundOuts)              AS groundOuts",
        "SUM(hitByPitch)              AS hitByPitch",
        "SUM(singles)+SUM(doubles)+SUM(triples)+SUM(homeRuns) AS hits",
        "SUM(homeRuns)                AS homeRuns",
        "SUM(intentionalWalks)        AS intentionalWalks",
        "SUM(lineOuts)                AS lineOuts",
        "SUM(passedBalls)             AS passedBalls",
        "SUM(popOuts)                 AS popOuts",
        "SUM(runsBattedIn)            AS runsBattedIn",
        "SUM(sacBunts)                AS sacBunts",
        "SUM(sacFlies)                AS sacFlies",
        "SUM(singles)                 AS singles",
        "SUM(strikeOuts)              AS strikeOuts",
        "SUM(triples)                 AS triples",
        "SUM(walks)                   AS walks",
        "SUM(wildPitches)             AS wildPitches",
        "SUM(balls)                   AS balls",
        "SUM(ballsPitchOut)           AS ballsPitchOut",
        "SUM(ballsInDirt)             AS ballsInDirt",
        "SUM(intentBalls)             AS intentBalls",
        "SUM(fouls)                   AS fouls",
        "SUM(foulBunts)               AS foulBunts",
        "SUM(foulTips)                AS foulTips",
        "SUM(foulPitchOuts)           AS foulPitchOuts",
        "SUM(hitIntoPlay)             AS hitIntoPlay",
        "SUM(pitches)                 AS pitches",
        "SUM(pitchOuts)               AS pitchOuts",
        "SUM(strikes)                 AS strikes",
        "SUM(strikesCalled)           AS strikesCalled",
        "SUM(strikesPitchOuts)        AS strikesPitchOuts",
        "SUM(missedBunts)             AS missedBunts",
        "SUM(swingAndMissStrikes)     AS swingAndMissStrikes",
        "SUM(swingsPitchOuts)         AS swingsPitchOuts",
        "SUM(swings)                  AS swings",
        "SUM(swingsZeroAndZero)       AS swingsZeroAndZero",
        "SUM(swingsZeroAndOne)        AS swingsZeroAndOne",
        "SUM(swingsZeroAndTwo)        AS swingsZeroAndTwo",
        "SUM(swingsOneAndZero)        AS swingsOneAndZero",
        "SUM(swingsOneAndOne)         AS swingsOneAndOne",
        "SUM(swingsOneAndTwo)         AS swingsOneAndTwo",
        "SUM(swingsTwoAndZero)        AS swingsTwoAndZero",
        "SUM(swingsTwoAndOne)         AS swingsTwoAndOne",
        "SUM(swingsTwoAndTwo)         AS swingsTwoAndTwo",
        "SUM(swingsThreeAndZero)      AS swingsThreeAndZero",
        "SUM(swingsThreeAndOne)       AS swingsThreeAndOne",
        "SUM(swingsThreeAndTwo)       AS swingsThreeAndTwo",
        "SUM(flyBalls)                AS flyBalls",
        "SUM(groundBalls)             AS groundBalls",
        "SUM(lineDrives)              AS lineDrives",
        "SUM(popUps)                  AS popUps",
        "SUM(groundBunts)             AS groundBunts",
        "SUM(popupBunts)              AS popupBunts",
        "SUM(lineDriveBunts)          AS lineDriveBunts",
    ]

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
INSERT INTO agg_batting_split_stats (
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
    """Write all INSERT statements to a .sql file."""
    header = """\
-- ============================================================
-- agg_batting_split_stats cube — SQLite3 static equivalent
-- Generated by agg_batting_split_stats_sqlite.py
-- Run with:  sqlite3 your_base.db < agg_batting_split_stats.sql
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
        description="Generate agg_batting_split_stats cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="agg_batting_split_stats.sql",
        help="Output .sql file path (default: agg_batting_split_stats.sql)",
    )
    args = parser.parse_args()
    generate_sql_file(args.output)
