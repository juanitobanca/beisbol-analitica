"""
agg_batting_stats_sqlite.py
────────────────────────────
Equivalent of the MySQL CALL agg_batting_stats(...) cube inserts,
rewritten as static SQL for SQLite3.

Each entry in GROUPINGS defines one "slice" of the cube:
  - fields: columns included in GROUP BY (the rest become NULL)
  - desc:   groupingDescription value

groupingId is derived automatically from a SHA-256 hash of the
sorted, comma-joined field names — stable across runs and unique
per combination of dimensions.

Usage:
    python agg_batting_stats_sqlite.py --db path/to/your.db
"""

import argparse
import hashlib

# ── Dimension columns that can appear in groupings ──────────────────────────
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
]

# ── Cube definitions  ────────────────────────────────────────────────────────
#   Mirror your original CALL sequence exactly.
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
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "officialId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "opposingTeamId"]},
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
    Using sorted() ensures the same set of fields always yields the same hash,
    regardless of the order they appear in the GROUPINGS definition.
    Takes the first 8 hex digits (32 bits) as an unsigned integer.
    """
    key = ",".join(sorted(fields))
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def grouping_desc(fields: list[str]) -> str:
    """
    e.g. ["majorLeagueId", "seasonId", "gameType2"] → "MAJORLEAGUEID_SEASONID_GAMETYPE2"
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
    INNER JOIN bs       ON g.gamePk = bs.gamePk
    LEFT  JOIN officials o ON g.gamePk = o.gamePk
)
"""


def build_select_exprs(active_fields: list[str]) -> list[str]:
    """
    For each dimension: SELECT the column if it's active, else NULL.
    Then append all aggregated stat expressions.
    """
    dim_exprs = [
        f"{col}" if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]

    stat_exprs = [
        f"SUM(atbats)                AS atbats",
        f"SUM(balks)                 AS balks",
        f"SUM(batterInterferences)   AS batterInterferences",
        f"SUM(bunts)                 AS bunts",
        f"SUM(catcherInterferences)  AS catcherInterferences",
        f"SUM(doubles)               AS doubles",
        f"SUM(fanInterferences)      AS fanInterferences",
        f"SUM(fieldErrors)           AS fieldErrors",
        f"SUM(fieldersChoice)        AS fieldersChoice",
        f"SUM(flyouts)               AS flyouts",
        f"SUM(forceOuts)             AS forceOuts",
        f"COUNT(DISTINCT gamePk)     AS games",
        f"SUM(groundedIntoDoublePlays) AS groundedIntoDoublePlays",
        f"SUM(triplePlays)           AS groundedIntoTriplePlays",
        f"SUM(groundOuts)            AS groundOuts",
        f"SUM(hitByPitch)            AS hitByPitch",
        f"SUM(singles)+SUM(doubles)+SUM(triples)+SUM(homeRuns) AS hits",
        f"SUM(homeRuns)              AS homeRuns",
        f"SUM(intentionalWalks)      AS intentionalWalks",
        f"SUM(lineOuts)              AS lineOuts",
        f"SUM(passedBalls)           AS passedBalls",
        f"SUM(popOuts)               AS popOuts",
        f"SUM(runsBattedIn)          AS runsBattedIn",
        f"SUM(sacBunts)              AS sacBunts",
        f"SUM(sacFlies)              AS sacFlies",
        f"SUM(singles)               AS singles",
        f"SUM(strikeOuts)            AS strikeOuts",
        f"SUM(triples)               AS triples",
        f"SUM(walks)                 AS walks",
        f"SUM(wildPitches)           AS wildPitches",
        # pitch metrics
        f"SUM(balls)                 AS balls",
        f"SUM(ballsPitchOut)         AS ballsPitchOut",
        f"SUM(ballsInDirt)           AS ballsInDirt",
        f"SUM(intentBalls)           AS intentBalls",
        f"SUM(fouls)                 AS fouls",
        f"SUM(foulBunts)             AS foulBunts",
        f"SUM(foulTips)              AS foulTips",
        f"SUM(foulPitchOuts)         AS foulPitchOuts",
        f"SUM(hitIntoPlay)           AS hitIntoPlay",
        f"SUM(pitches)               AS pitches",
        f"SUM(pitchOuts)             AS pitchOuts",
        f"SUM(strikes)               AS strikes",
        f"SUM(strikesCalled)         AS strikesCalled",
        f"SUM(strikesPitchOuts)      AS strikesPitchOuts",
        f"SUM(missedBunts)           AS missedBunts",
        f"SUM(swingAndMissStrikes)   AS swingAndMissStrikes",
        f"SUM(swingsPitchOuts)       AS swingsPitchOuts",
        f"SUM(swings)                AS swings",
        f"SUM(swingsZeroAndZero)     AS swingsZeroAndZero",
        f"SUM(swingsZeroAndOne)      AS swingsZeroAndOne",
        f"SUM(swingsZeroAndTwo)      AS swingsZeroAndTwo",
        f"SUM(swingsOneAndZero)      AS swingsOneAndZero",
        f"SUM(swingsOneAndOne)       AS swingsOneAndOne",
        f"SUM(swingsOneAndTwo)       AS swingsOneAndTwo",
        f"SUM(swingsTwoAndZero)      AS swingsTwoAndZero",
        f"SUM(swingsTwoAndOne)       AS swingsTwoAndOne",
        f"SUM(swingsTwoAndTwo)       AS swingsTwoAndTwo",
        f"SUM(swingsThreeAndZero)    AS swingsThreeAndZero",
        f"SUM(swingsThreeAndOne)     AS swingsThreeAndOne",
        f"SUM(swingsThreeAndTwo)     AS swingsThreeAndTwo",
        f"SUM(flyBalls)              AS flyBalls",
        f"SUM(groundBalls)           AS groundBalls",
        f"SUM(lineDrives)            AS lineDrives",
        f"SUM(popUps)                AS popUps",
        f"SUM(groundBunts)           AS groundBunts",
        f"SUM(popupBunts)            AS popupBunts",
        f"SUM(lineDriveBunts)        AS lineDriveBunts",
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
INSERT INTO agg_batting_stats (
        {cols_str}
)
{build_cte().strip()}
SELECT
        {selects_str},
        {gid}      AS groupingId,
        '{gdesc}'  AS groupingDescription
FROM data
GROUP BY {group_by};
"""


def generate_sql_file(output_path: str) -> None:
    """Write all INSERT statements to a .sql file."""
    header = """\
-- ============================================================
-- agg_batting_stats cube — SQLite3 static equivalent
-- Generated by agg_batting_stats_sqlite.py
-- Run with:  sqlite3 your_base.db < agg_batting_stats_cube.sql
-- ============================================================

BEGIN;
"""
    footer = "\nCOMMIT;\n"

    statements = [build_insert(g) for g in GROUPINGS]

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(header)
        for sql in statements:
            f.write(sql)
            f.write("\n")
        f.write(footer)

    print(f"✓ SQL file written to: {output_path}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Generate agg_batting_stats SQL for SQLite3")
    parser.add_argument(
        "--output", required=False,
        default="agg_batting_stats.sql",
        help="Output .sql file path (default: agg_batting_stats.sql)"
    )
    args = parser.parse_args()

    generate_sql_file(args.output)
