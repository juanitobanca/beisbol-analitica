"""
agg_pitching_stats_sqlite.py
─────────────────────────────
Equivalent of the MySQL CALL agg_pitching_stats(...) cube inserts,
rewritten as static SQL for SQLite3.

Key differences from batting scripts:
  - Target table  : agg_pitching_stats
  - Sources       : games + game_player_pitching_stats + game_player_split_stats
                    + game_officials
  - Extra dims    : opposingTeamId, officialId
  - Two-level agg : inner CTE 'd' groups once, outer SELECT sums again
  - aggregationType always 'AGGREGATED'

groupingId   → SHA-256 of sorted field names (first 8 hex digits as int)
groupingDesc → field names uppercased, joined by '_'

Usage:
    python agg_pitching_stats_sqlite.py [--output agg_pitching_stats.sql]
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
]

# ── How each dimension maps to a SQL expression inside the inner CTE 'd' ─────
# These reference the aliased tables: g, bs, ss, o
DIM_EXPR = {
    "majorLeagueId":  "g.majorLeagueId",
    "seasonId":       "g.seasonId",
    "gameType2":      "g.gameType2",
    "teamId":         "bs.teamId",
    "teamType":       "CASE WHEN g.homeTeamId = bs.teamId THEN 'home' ELSE 'away' END",
    "playerId":       "bs.playerId",
    "venueId":        "g.venueId",
    "officialId":     "o.officialId",
    "opposingTeamId": "ss.opposingTeamId",
}

# ── Groupings — direct translation of each CALL ──────────────────────────────
GROUPINGS = [
    {"fields": ["majorLeagueId", "seasonId", "gameType2"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "venueId", "teamId", "teamType"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "teamType"]},
    {"fields": ["majorLeagueId", "seasonId", "officialId"]},
    {"fields": ["majorLeagueId", "seasonId", "gameType2", "opposingTeamId"]},
]

# ── Stat columns (order matches INSERT target table) ─────────────────────────
PITCHING_STAT_COLS = [
    "airOuts", "atBats", "walks", "battersFaced", "blownSaves",
    "catcherInterferences", "caughtStealing", "completeGames", "doubles",
    "earnedRuns", "gamesFinished", "gamesPitched", "gamesPlayed", "gamesStarted",
    "groundOuts", "hitBatsmen", "hits", "holds", "homeRuns",
    "inheritedRunners", "inheritedRunnersScored", "intentionalWalks", "losses",
    "numberOfPitches", "outs", "pickoffs", "pitchesThrown", "plateAppearances",
    "rbi", "runs", "sacBunts", "sacFlies", "saveOpportunities", "saves",
    "singles", "shutouts", "stolenBases", "strikeOuts", "triples",
    "unintentionalWalks", "wildPitches", "wins",
]

PITCH_METRIC_COLS = [
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

STAT_COLS = PITCHING_STAT_COLS + PITCH_METRIC_COLS


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
    # Dimension SELECT expressions inside 'd', using table-aliased sources
    dim_exprs_inner = []
    for col in ALL_DIMS:
        if col in active_fields:
            dim_exprs_inner.append(f"{DIM_EXPR[col]} AS {col}")
        else:
            dim_exprs_inner.append(f"NULL AS {col}")

    dim_select_inner = ",\n        ".join(dim_exprs_inner)
    group_by_inner   = ", ".join(DIM_EXPR[f] for f in active_fields)

    return f"""
WITH game_split_stats AS (
    SELECT
        gamePk, pitcherId,
        battingTeamId AS opposingTeamId,
        SUM(balks)               AS balks,
        SUM(batterInterferences) AS batterInterferences,
        SUM(bunts)               AS bunts,
        SUM(fanInterferences)    AS fanInterferences,
        SUM(fieldErrors)         AS fieldErrors,
        SUM(fieldersChoice)      AS fieldersChoice,
        SUM(forceOuts)           AS forceOuts,
        SUM(lineOuts)            AS lineOuts,
        SUM(passedBalls)         AS passedBalls,
        SUM(popOuts)             AS popOuts,
        SUM(wildPitches)         AS wildPitches,
        SUM(balls)               AS balls,
        SUM(ballsPitchOut)       AS ballsPitchOut,
        SUM(ballsInDirt)         AS ballsInDirt,
        SUM(intentBalls)         AS intentBalls,
        SUM(fouls)               AS fouls,
        SUM(foulBunts)           AS foulBunts,
        SUM(foulTips)            AS foulTips,
        SUM(foulPitchOuts)       AS foulPitchOuts,
        SUM(hitIntoPlay)         AS hitIntoPlay,
        SUM(pitches)             AS pitches,
        SUM(pitchOuts)           AS pitchOuts,
        SUM(strikes)             AS strikes,
        SUM(strikesCalled)       AS strikesCalled,
        SUM(strikesPitchOuts)    AS strikesPitchOuts,
        SUM(missedBunts)         AS missedBunts,
        SUM(swingAndMissStrikes) AS swingAndMissStrikes,
        SUM(swingsPitchOuts)     AS swingsPitchOuts,
        SUM(swings)              AS swings,
        SUM(swingsZeroAndZero)   AS swingsZeroAndZero,
        SUM(swingsZeroAndOne)    AS swingsZeroAndOne,
        SUM(swingsZeroAndTwo)    AS swingsZeroAndTwo,
        SUM(swingsOneAndZero)    AS swingsOneAndZero,
        SUM(swingsOneAndOne)     AS swingsOneAndOne,
        SUM(swingsOneAndTwo)     AS swingsOneAndTwo,
        SUM(swingsTwoAndZero)    AS swingsTwoAndZero,
        SUM(swingsTwoAndOne)     AS swingsTwoAndOne,
        SUM(swingsTwoAndTwo)     AS swingsTwoAndTwo,
        SUM(swingsThreeAndZero)  AS swingsThreeAndZero,
        SUM(swingsThreeAndOne)   AS swingsThreeAndOne,
        SUM(swingsThreeAndTwo)   AS swingsThreeAndTwo,
        SUM(flyBalls)            AS flyBalls,
        SUM(groundBalls)         AS groundBalls,
        SUM(lineDrives)          AS lineDrives,
        SUM(popUps)              AS popUps,
        SUM(groundBunts)         AS groundBunts,
        SUM(popupBunts)          AS popupBunts,
        SUM(lineDriveBunts)      AS lineDriveBunts
    FROM game_player_split_stats
    GROUP BY gamePk, pitcherId, battingTeamId
),
officials AS (
    SELECT gamePk, officialId
    FROM game_officials
    WHERE position = 'Home Plate'
),
d AS (
    SELECT
        {dim_select_inner},
        SUM(bs.airOuts)                  AS airOuts,
        SUM(bs.atBats)                   AS atBats,
        SUM(bs.walks)                    AS walks,
        SUM(bs.battersFaced)             AS battersFaced,
        SUM(bs.blownSaves)               AS blownSaves,
        SUM(bs.catchersInterference)     AS catcherInterferences,
        SUM(bs.caughtStealing)           AS caughtStealing,
        SUM(bs.completeGames)            AS completeGames,
        SUM(bs.doubles)                  AS doubles,
        SUM(bs.earnedRuns)               AS earnedRuns,
        SUM(bs.gamesFinished)            AS gamesFinished,
        SUM(bs.gamesPitched)             AS gamesPitched,
        SUM(bs.gamesPlayed)              AS gamesPlayed,
        SUM(bs.gamesStarted)             AS gamesStarted,
        SUM(bs.groundOuts)               AS groundOuts,
        SUM(bs.hitBatsmen)               AS hitBatsmen,
        SUM(bs.hits)                     AS hits,
        SUM(bs.holds)                    AS holds,
        SUM(bs.homeRuns)                 AS homeRuns,
        SUM(bs.inheritedRunners)         AS inheritedRunners,
        SUM(bs.inheritedRunnersScored)   AS inheritedRunnersScored,
        SUM(bs.intentionalWalks)         AS intentionalWalks,
        SUM(bs.losses)                   AS losses,
        SUM(bs.numberOfPitches)          AS numberOfPitches,
        SUM(bs.outs)                     AS outs,
        SUM(bs.pickoffs)                 AS pickoffs,
        SUM(bs.pitchesThrown)            AS pitchesThrown,
        SUM(bs.plateAppearances)         AS plateAppearances,
        SUM(bs.rbi)                      AS rbi,
        SUM(bs.runs)                     AS runs,
        SUM(bs.sacBunts)                 AS sacBunts,
        SUM(bs.sacFlies)                 AS sacFlies,
        SUM(bs.saveOpportunities)        AS saveOpportunities,
        SUM(bs.saves)                    AS saves,
        SUM(bs.singles)                  AS singles,
        SUM(bs.shutouts)                 AS shutouts,
        SUM(bs.stolenBases)              AS stolenBases,
        SUM(bs.strikeOuts)               AS strikeOuts,
        SUM(bs.triples)                  AS triples,
        SUM(bs.unintentionalWalks)       AS unintentionalWalks,
        SUM(ss.wildPitches)              AS wildPitches,
        SUM(bs.wins)                     AS wins,
        SUM(ss.balls)                    AS balls,
        SUM(ss.ballsPitchOut)            AS ballsPitchOut,
        SUM(ss.ballsInDirt)              AS ballsInDirt,
        SUM(ss.intentBalls)              AS intentBalls,
        SUM(ss.fouls)                    AS fouls,
        SUM(ss.foulBunts)                AS foulBunts,
        SUM(ss.foulTips)                 AS foulTips,
        SUM(ss.foulPitchOuts)            AS foulPitchOuts,
        SUM(ss.hitIntoPlay)              AS hitIntoPlay,
        SUM(ss.pitches)                  AS pitches,
        SUM(ss.pitchOuts)                AS pitchOuts,
        SUM(ss.strikes)                  AS strikes,
        SUM(ss.strikesCalled)            AS strikesCalled,
        SUM(ss.strikesPitchOuts)         AS strikesPitchOuts,
        SUM(ss.missedBunts)              AS missedBunts,
        SUM(ss.swingAndMissStrikes)      AS swingAndMissStrikes,
        SUM(ss.swingsPitchOuts)          AS swingsPitchOuts,
        SUM(ss.swings)                   AS swings,
        SUM(ss.swingsZeroAndZero)        AS swingsZeroAndZero,
        SUM(ss.swingsZeroAndOne)         AS swingsZeroAndOne,
        SUM(ss.swingsZeroAndTwo)         AS swingsZeroAndTwo,
        SUM(ss.swingsOneAndZero)         AS swingsOneAndZero,
        SUM(ss.swingsOneAndOne)          AS swingsOneAndOne,
        SUM(ss.swingsOneAndTwo)          AS swingsOneAndTwo,
        SUM(ss.swingsTwoAndZero)         AS swingsTwoAndZero,
        SUM(ss.swingsTwoAndOne)          AS swingsTwoAndOne,
        SUM(ss.swingsTwoAndTwo)          AS swingsTwoAndTwo,
        SUM(ss.swingsThreeAndZero)       AS swingsThreeAndZero,
        SUM(ss.swingsThreeAndOne)        AS swingsThreeAndOne,
        SUM(ss.swingsThreeAndTwo)        AS swingsThreeAndTwo,
        SUM(ss.flyBalls)                 AS flyBalls,
        SUM(ss.groundBalls)              AS groundBalls,
        SUM(ss.lineDrives)               AS lineDrives,
        SUM(ss.popUps)                   AS popUps,
        SUM(ss.groundBunts)              AS groundBunts,
        SUM(ss.popupBunts)               AS popupBunts,
        SUM(ss.lineDriveBunts)           AS lineDriveBunts
    FROM games g
    INNER JOIN game_player_pitching_stats bs
        ON  g.gamePk   = bs.gamePk
    INNER JOIN game_split_stats ss
        ON  bs.gamePk  = ss.gamePk
        AND bs.playerId = ss.pitcherId
    LEFT  JOIN officials o
        ON  g.gamePk   = o.gamePk
    WHERE g.gameType2 IN ('PS', 'RS')
    GROUP BY {group_by_inner}
)"""


def build_select_exprs(active_fields: list[str]) -> list[str]:
    """
    Dimension columns: active → pass through from 'd', inactive → NULL.
    Stat columns: all plain SUM() over the already-grouped 'd' CTE.
    """
    dim_exprs  = [
        col if col in active_fields else f"NULL AS {col}"
        for col in ALL_DIMS
    ]
    stat_exprs = [f"SUM({col}) AS {col}" for col in STAT_COLS]
    return dim_exprs + stat_exprs


def build_insert(grouping: dict) -> str:
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
INSERT INTO agg_pitching_stats (
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
-- agg_pitching_stats cube — SQLite3 static equivalent
-- Generated by agg_pitching_stats_sqlite.py
-- Run with:  sqlite3 your_base.db < agg_pitching_stats.sql
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
        description="Generate agg_pitching_stats cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="../pitching/procedimientos/agg_pitching_stats.sql",
        help="Output .sql file path (default: agg_pitching_stats.sql)",
    )
    args = parser.parse_args()
    generate_sql_file(args.output)
