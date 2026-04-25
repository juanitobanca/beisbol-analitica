"""
agg_pitching_split_stats_sqlite.py
────────────────────────────────────
Equivalent of the MySQL CALL agg_pitching_split_stats(...) cube inserts,
rewritten as static SQL for SQLite3.

Differences from agg_batting_split_stats:
  - Target table : agg_pitching_split_stats
  - bs CTE       : battingTeamId AS opposingTeamId  (batting used pitchingTeamId)
  - Stat cols    : doublePlays / triplePlays / hitBatsmen
                   (batting used groundedIntoDoublePlays / groundedIntoTriplePlays / hitByPitch)

groupingId   → SHA-256 of sorted field names (first 8 hex digits as int)
groupingDesc → field names uppercased, joined by '_'

Usage:
    python agg_pitching_split_stats_sqlite.py [--output agg_pitching_split_stats.sql]
"""

import argparse
from cube_utils import grouping_id, grouping_desc, generate_sql_file

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
# Note: doublePlays / triplePlays / hitBatsmen differ from the batting version
STAT_COLS = [
    "atbats", "balks", "batterInterferences", "bunts", "catcherInterferences",
    "doubles", "fanInterferences", "fieldErrors", "fieldersChoice", "flyouts",
    "forceOuts", "games", "doublePlays", "triplePlays", "groundOuts",
    "hitBatsmen", "hits", "homeRuns", "intentionalWalks", "lineOuts",
    "passedBalls", "popOuts", "runsBattedIn", "sacBunts", "sacFlies",
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






def build_cte() -> str:
    """CTEs shared by every grouping query.
    Key difference from batting: bs uses battingTeamId AS opposingTeamId
    because we're aggregating from the pitcher's perspective.
    """
    return """
WITH bs AS (
    SELECT *, battingTeamId AS opposingTeamId
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
        bs.opposingTeamId,
        bs.batterId       AS playerId,
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
    Dimension columns: active → pass through, inactive → NULL.
    Stat columns: mapped to their correct source expression.
    """
    dim_exprs = [
        col if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]

    # A few stat columns have different source names vs target names
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
        "SUM(groundedIntoDoublePlays) AS doublePlays",   # ← renamed from batting
        "SUM(triplePlays)             AS triplePlays",   # ← renamed from batting
        "SUM(groundOuts)              AS groundOuts",
        "SUM(hitByPitch)              AS hitBatsmen",    # ← renamed from batting
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
INSERT INTO agg_pitching_split_stats (
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



if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate agg_pitching_split_stats cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="../pitching/procedimientos/agg_pitching_split_stats.sql",
        help="Output .sql file path (default: agg_pitching_split_stats.sql)",
    )
    args = parser.parse_args()
    generate_sql_file(args.output, "agg_pitching_split_stats", GROUPINGS, build_insert)
