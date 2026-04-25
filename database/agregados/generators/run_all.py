"""
run_all.py
──────────
Corre todos los generadores de cubos SQL en secuencia.

Uso básico (usa los output paths por defecto de cada generador):
    python run_all.py

Sobreescribir el directorio de salida:
    python run_all.py --outdir /ruta/a/tu/carpeta

Con --outdir, los archivos se guardan así:
    /ruta/a/tu/carpeta/agg_batting_stats.sql
    /ruta/a/tu/carpeta/agg_fielding_stats.sql
    ... etc.
"""

import argparse
import sys
import traceback
from pathlib import Path

# Importa la función generate_sql_file y los datos de cada generador
import agg_batting_balls_in_play_heatmaps  as batting_bip
import agg_batting_split_stats_generator   as batting_split
import agg_batting_stats_generator         as batting_stats
import agg_fielding_stats                  as fielding
import agg_pitching_balls_in_play_heatmaps as pitching_bip
import agg_pitching_split_stats            as pitching_split
import agg_pitching_stats                  as pitching_stats
import agg_team_performance_stats          as team_perf

from cube_utils import generate_sql_file

# ── Registro de generadores ──────────────────────────────────────────────────
# (módulo, cube_name, output_filename)
GENERATORS = [
    (batting_stats,  "agg_batting_stats",                    "agg_batting_stats.sql"),
    (batting_split,  "agg_batting_split_stats",              "agg_batting_split_stats.sql"),
    (batting_bip,    "agg_batting_balls_in_play_heatmaps",   "agg_batting_balls_in_play_heatmaps.sql"),
    (fielding,       "agg_fielding_stats",                   "agg_fielding_stats.sql"),
    (pitching_stats, "agg_pitching_stats",                   "agg_pitching_stats.sql"),
    (pitching_split, "agg_pitching_split_stats",             "agg_pitching_split_stats.sql"),
    (pitching_bip,   "agg_pitching_balls_in_play_heatmaps",  "agg_pitching_balls_in_play_heatmaps.sql"),
    (team_perf,      "agg_team_performance_stats",           "agg_team_performance_stats.sql"),
]


def main() -> None:
    parser = argparse.ArgumentParser(description="Corre todos los generadores de cubos SQL")
    parser.add_argument(
        "--outdir",
        default=None,
        help="Directorio de salida. Si no se indica, cada generador usa su path por defecto.",
    )
    args = parser.parse_args()

    outdir = Path(args.outdir) if args.outdir else None
    if outdir:
        outdir.mkdir(parents=True, exist_ok=True)

    ok = failed = 0

    for mod, cube_name, filename in GENERATORS:
        if outdir:
            output_path = str(outdir / filename)
        else:
            # Usa el default hardcodeado en cada módulo
            output_path = mod.__file__.replace(".py", "_default_run")
            # Reconstruye el default desde el argparse del módulo
            import importlib, argparse as ap
            sub = ap.ArgumentParser()
            sub.add_argument("--output")
            # Tomamos el default directamente del módulo
            defaults = {
                "agg_batting_stats":                   "../batting/procedimientos/agg_batting_stats.sql",
                "agg_batting_split_stats":             "../batting/procedimientos/agg_batting_split_stats.sql",
                "agg_batting_balls_in_play_heatmaps":  "../batting/procedimientos/agg_batting_balls_in_play_heatmaps.sql",
                "agg_fielding_stats":                  "../fielding/procedimientos/agg_fielding_stats.sql",
                "agg_pitching_stats":                  "../pitching/procedimientos/agg_pitching_stats.sql",
                "agg_pitching_split_stats":            "../pitching/procedimientos/agg_pitching_split_stats.sql",
                "agg_pitching_balls_in_play_heatmaps": "../pitching/procedimientos/agg_pitching_balls_in_play_heatmaps.sql",
                "agg_team_performance_stats":          "../team_performance/agg_team_performance_stats.sql",
            }
            output_path = defaults[cube_name]

        try:
            generate_sql_file(output_path, cube_name, mod.GROUPINGS, mod.build_insert)
            ok += 1
        except Exception:
            print(f"✗ {cube_name} — ERROR:")
            traceback.print_exc()
            failed += 1

    print(f"\n{'─'*50}")
    print(f"  {ok} generados correctamente  |  {failed} con error")
    if failed:
        sys.exit(1)


if __name__ == "__main__":
    main()
