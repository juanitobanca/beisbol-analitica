from_season=2018
to_season=2026
last_season_remaining=2026
leagues="MLB LMB DSL LIDOM LMP LBPRC VSL LVBP WBCQ WBC SDC"

run_league() {
  local l=$1
  echo "${l}"

  for s in $(seq ${from_season} ${to_season}); do
    echo "${l} - ${s}"
    python3 orchestrator.py --startDate=${s}-01-01 --endDate=${s}-12-31 --batch=5000 --lg=${l}
  done

  echo "${l} - ${last_season_remaining}"
  python3 orchestrator.py --startDate=${last_season_remaining}-01-01 --endDate=${last_season_remaining}-03-01 --batch=50000 --lg=${l}
}

for l in ${leagues}; do
  run_league "$l" &
done

wait
echo "All leagues done!"
