setopt shwordsplit 

from_season=2006
to_season=2021
last_season_remaining=2022
leagues="WBC SDC LMP LIDOM LVBP LMB MLB DSL LBPRC"

for l in ${leagues}
do

  echo "${l}"

  for s in $(seq ${from_season} ${to_season})
  do
  
    echo "${s}"
    python3.6 orchestrator.py --startDate=${s}-01-01 --endDate=${s}-12-31 --batch=50000 --lg=${l} --con="mysql://juanito:banca@localhost/baseball?use_unicode=1&charset=utf8"
    echo "use baseball; call master_procedure();" | mysql -u juanito -pbanca baseball &> /dev/null
  done

    echo "${last_season_remaining}"
    python3.6 orchestrator.py --startDate=${last_season_remaining}-01-01 --endDate=${last_season_remaining}-03-01 --batch=50000 --lg=${l} --con="mysql://juanito:banca@localhost/baseball?use_unicode=1&charset=utf8"
    echo "use baseball; call master_procedure();" | mysql -u juanito -pbanca baseball &> /dev/null
done