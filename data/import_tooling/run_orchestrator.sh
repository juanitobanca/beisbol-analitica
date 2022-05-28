setopt shwordsplit 

from_season=2006
to_season=2021
last_season_remaining=2022
leagues="WBC SDC LMP LIDOM LVBP LMB AL NL DSL LBPRC CCBL CB1 CB2"

for l in ${leagues}
do
  echo "${l}"
  for s in $(seq ${from_season} ${to_season})
  do
    echo "${s}"
    python3 data/import_tooling/orchestrator.py --startDate=01/01/${s} --endDate=12/31/${s} --batch=50000 --lg=${l}
  done
    echo "${last_season_remaining}"
    python3 data/import_tooling/orchestrator.py --startDate=01/01/${last_season_remaining} --endDate=03/01/${last_season_remaining} --batch=50000 --lg=${l}
done
