pip3 install virtualenv
python3 -m virtualenv ./.venv
source ./.venv/bin/activate

pip3 install -r requirements.txt

python3 data/import_tooling/orchestrator.py --teams 'BOS Red Sox,MIL Brewers' --start_date '05/20/2022' --end_date '05/26/2022'
