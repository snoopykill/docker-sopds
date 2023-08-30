python3 manage.py migrate
python3 manage.py sopds_util clear
python3 manage.py sopds_scanner start --daemon
python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY True
