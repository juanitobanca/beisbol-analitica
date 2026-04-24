"""
we_win_probability_added_sqlite.py
────────────────────────────────────
Equivalent of the MySQL CALL we_win_probability_added(...) inserts,
rewritten as static SQL for SQLite3.

This procedure is more complex than the aggregation scripts because it has
TWO sets of fields per call:

  p_fields          — source columns selected from pbp (e.g. batterId, runnerId)
  p_grouping_fields — target column names in the output table (e.g. playerId, teamId)

Additional per-call logic:
  - batterId  fields → WHERE runnerId IS NULL
  - runnerId  fields → WHERE runnerId IS NOT NULL
  - pitcherId / teamId fields → no runner filter

groupingId          → SHA-256 of sorted p_grouping_fields (first 8 hex digits as uint)
groupingDescription → p_grouping_fields uppercased, joined by '_'
groupingFields      → p_fields uppercased, joined by '_'

Usage:
    python we_win_probability_added_sqlite.py [--output we_win_probability_added.sql]
"""

import argparse
import hashlib

# ── Field mapping: source pbp column → target alias in output ────────────────
# Common dimension fields map to themselves.
# Player/team role fields map to their generic output alias.
FIELD_ALIAS = {
    "majorLeagueId":  "majorLeagueId",
    "seasonId":       "seasonId",
    "gameType2":      "gameType2",
    "batterId":       "playerId",
    "runnerId":       "playerId",
    "pitcherId":      "playerId",
    "battingTeamId":  "teamId",
    "pitchingTeamId": "teamId",
}

# ── Runner filter logic ───────────────────────────────────────────────────────
# Key = source field that triggers the filter
RUNNER_FILTER = {
    "batterId":  "WHERE runnerId IS NULL",
    "runnerId":  "WHERE runnerId IS NOT NULL",
    # pitcherId / teamId fields: no filter
}

# ── Groupings — direct translation of each CALL ──────────────────────────────
# p_fields          : source columns used inside the data CTE
# p_grouping_fields : output column names (for INSERT + GROUP BY)
GROUPINGS = [
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "runnerId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "playerId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "batterId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "playerId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "pitcherId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "playerId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "battingTeamId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "teamId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "pitchingTeamId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "teamId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "battingTeamId", "runnerId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "battingTeamId", "batterId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId"],
    },
    {
        "p_fields":          ["majorLeagueId", "seasonId", "gameType2", "pitchingTeamId", "pitcherId"],
        "p_grouping_fields": ["majorLeagueId", "seasonId", "gameType2", "teamId", "playerId"],
    },
]


def grouping_id(fields: list[str]) -> int:
    """Stable integer ID: SHA-256 of sorted p_grouping_fields, first 8 hex digits as uint."""
    key = ",".join(sorted(fields))
    return int(hashlib.sha256(key.encode()).hexdigest()[:8], 16)


def grouping_desc(fields: list[str]) -> str:
    return "_".join(f.upper() for f in fields)


def runner_filter(p_fields: list[str]) -> str:
    """Return the WHERE clause triggered by a role field, or empty string."""
    for f in p_fields:
        if f in RUNNER_FILTER:
            return RUNNER_FILTER[f]
    return ""


def build_data_select_exprs(p_fields: list[str]) -> list[str]:
    """
    Build the SELECT expressions inside the 'data' CTE.
    Each source field is aliased to its target name via FIELD_ALIAS.
    """
    seen_aliases = set()
    exprs = []
    for f in p_fields:
        alias = FIELD_ALIAS[f]
        if alias in seen_aliases:
            continue  # avoid duplicate aliases (e.g. if two fields map to playerId)
        seen_aliases.add(alias)
        if f == alias:
            exprs.append(f"pbp.{f}")
        else:
            exprs.append(f"pbp.{f} AS {alias}")
    exprs += [
        "a.winExpectancy - b.winExpectancy              AS offensiveWinProbabilityAdded",
        "-1 * (a.winExpectancy - b.winExpectancy)       AS defensiveWinProbabilityAdded",
    ]
    return exprs


def build_insert(grouping: dict) -> str:
    p_fields          = grouping["p_fields"]
    p_grouping_fields = grouping["p_grouping_fields"]

    gid        = grouping_id(p_grouping_fields)
    gdesc      = grouping_desc(p_grouping_fields)
    gfields    = grouping_desc(p_fields)           # groupingFields = uppercase p_fields
    wfilter    = runner_filter(p_fields)
    group_by   = ", ".join(p_grouping_fields)

    # INSERT target columns
    insert_cols = p_grouping_fields + [
        "offensiveWinProbabilityAdded",
        "defensiveWinProbabilityAdded",
        "groupingId",
        "groupingDescription",
        "groupingFields",
    ]

    # data CTE SELECT
    data_exprs     = build_data_select_exprs(p_fields)
    data_exprs_str = ",\n        ".join(data_exprs)

    # outer SELECT expressions
    outer_dim_exprs = [f"SUM({col}) -- use {col} directly\n        {col}" if False
                       else col
                       for col in p_grouping_fields]
    outer_select = ",\n        ".join(
        p_grouping_fields + [
            "SUM(offensiveWinProbabilityAdded) AS offensiveWinProbabilityAdded",
            "SUM(defensiveWinProbabilityAdded) AS defensiveWinProbabilityAdded",
        ]
    )

    where_clause = f"\n{wfilter}" if wfilter else ""

    cols_str = ",\n        ".join(insert_cols)

    return f"""
-- ── {gfields} → {gdesc} ──────────────────────────────────────────────
INSERT INTO we_win_probability_added (
        {cols_str}
)
WITH we AS (
    -- Win expectancy aggregated across all seasons for the given game type
    SELECT
        majorLeagueId,
        CASE WHEN inning > 9 THEN 10 ELSE inning END AS inning,
        menOnBase, outs, score,
        SUM(wins) * 1.0 / SUM(games) AS winExpectancy
    FROM we_win_expectancy
    WHERE groupingDescription = 'MAJORLEAGUEID_SEASONID_INNING_GAMETYPE2_MENONBASE_OUTS'
      AND gameType2 = 'RS'
    GROUP BY majorLeagueId, inning, menOnBase, outs, score
),
pbp AS (
    SELECT
        majorLeagueId, seasonId, gameType2,
        battingTeamId, pitchingTeamId, batterId, batSide,
        runnerId, pitcherId, pitchHand,
        menOnBaseBeforePlay,
        outsBeforePlay,
        CASE WHEN inning > 9 THEN 10 ELSE inning END AS inning,
        CASE
            WHEN battingTeamScore - pitchingTeamScore < 0 THEN 'LOSING'
            WHEN battingTeamScore - pitchingTeamScore > 0 THEN 'WINNING'
            ELSE 'TIE'
        END AS scoreBeforePlay,
        CASE WHEN outsAfterPlay >= 3 THEN 3 ELSE outsAfterPlay END AS outsAfterPlay,
        CASE
            WHEN (battingTeamScore + runsScoredInPlay) - pitchingTeamScore < 0 THEN 'LOSING'
            WHEN (battingTeamScore + runsScoredInPlay) - pitchingTeamScore > 0 THEN 'WINNING'
            ELSE 'TIE'
        END AS scoreAfterPlay,
        -- menOnBaseAfterPlay is always 'Empty' when outsAfterPlay >= 3
        'Empty' AS menOnBaseAfterPlay
    FROM rem_play_by_play
),
data AS (
    SELECT
        {data_exprs_str}
    FROM pbp
    -- Join win expectancy for the state BEFORE the play
    INNER JOIN we b
        ON  pbp.majorLeagueId       = b.majorLeagueId
        AND pbp.inning               = b.inning
        AND pbp.menOnBaseBeforePlay  = b.menOnBase
        AND pbp.outsBeforePlay       = b.outs
        AND pbp.scoreBeforePlay      = b.score
    -- Join win expectancy for the state AFTER the play
    INNER JOIN we a
        ON  pbp.majorLeagueId       = a.majorLeagueId
        AND pbp.inning               = a.inning
        AND pbp.menOnBaseAfterPlay   = a.menOnBase
        AND pbp.outsAfterPlay        = a.outs
        AND pbp.scoreAfterPlay       = a.score{where_clause}
)
SELECT
        {outer_select},
        {gid}        AS groupingId,
        '{gdesc}'    AS groupingDescription,
        '{gfields}'  AS groupingFields
FROM data
GROUP BY {group_by};
"""


def generate_sql_file(output_path: str) -> None:
    header = """\
-- ============================================================
-- we_win_probability_added cube — SQLite3 static equivalent
-- Generated by we_win_probability_added_sqlite.py
-- Run with:  sqlite3 your_base.db < we_win_probability_added.sql
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
        description="Generate we_win_probability_added cube SQL for SQLite3"
    )
    parser.add_argument(
        "--output", required=False,
        default="we_win_probability_added.sql",
        help="Output .sql file path (default: we_win_probability_added.sql)",
    )
    args = parser.parse_args()
    generate_sql_file(args.output)
