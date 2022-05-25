pip3 install virtualenv
python3 -m virtualenv ./.venv
source ./.venv/bin/activate

pip3 install -r requirements.txt

python3 data/import_tooling/orchestrator.py
