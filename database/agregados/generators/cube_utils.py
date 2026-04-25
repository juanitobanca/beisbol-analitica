"""
cube_utils.py
─────────────
Shared utilities for all agg_* SQL cube generators.

Functions extracted here are byte-for-byte equivalent across all 8 generators:
  - grouping_id(fields)          → stable SHA-256-based integer ID
  - grouping_desc(fields)        → uppercased underscore-joined description
  - generate_sql_file(...)       → writes BEGIN/INSERT.../COMMIT to disk
"""

import hashlib


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


def generate_sql_file(
    output_path: str,
    cube_name: str,
    groupings: list[dict],
    build_insert_fn,
) -> None:
    """
    Write all INSERT statements for a cube to a .sql file.

    Args:
        output_path:     Destination .sql file path.
        cube_name:       Human-readable cube name used in the file header comment,
                         e.g. "agg_batting_stats".
        groupings:       List of grouping dicts, each with at least a "fields" key.
        build_insert_fn: Callable(grouping: dict) -> str  — the per-cube
                         INSERT builder. Each generator passes its own local
                         build_insert function here.
    """
    header = (
        "-- ============================================================\n"
        f"-- {cube_name} cube — SQLite3 static equivalent\n"
        f"-- Run with:  sqlite3 your_base.db < {cube_name}.sql\n"
        "-- ============================================================\n"
        "\nBEGIN;\n"
    )
    footer = "\nCOMMIT;\n"

    with open(output_path, "w", encoding="utf-8") as f:
        f.write(header)
        for grouping in groupings:
            f.write(build_insert_fn(grouping))
            f.write("\n")
        f.write(footer)

    print(f"✓ SQL file written to: {output_path}")
