from_season=2006
to_season=2025
last_season_remaining=2026
leagues="MLB LMB DSL LIDOM LMP LBPRC VSL LVBP WBCQ WBC SDC"

for l in $leagues; do
  echo "${l}"

  for s in $(seq ${from_season} ${to_season}); do
    echo "${l} - ${s}"
    python3 orchestrator.py --startDate=${s}-01-01 --endDate=${s}-12-31 --batch=50000 --lg=${l}
  done

  # last partial season
  echo "${l} - ${last_season_remaining}"
  python3 orchestrator.py --startDate=${last_season_remaining}-01-01 --endDate=${last_season_remaining}-03-01 --batch=50000 --lg=${l}

done

echo "All leagues done!"
