#!/bin/bash

#DB
if [ $MIGRATE == True ]; then
python3 manage.py migrate
fi
if [ $DBCLEAR == True ]; then
python3 manage.py sopds_util clear
expect /sopds/superuser.exp
fi
python3 manage.py sopds_util setconf SOPDS_ROOT_LIB "/books"
python3 manage.py sopds_util setconf SOPDS_AUTH False
python3 manage.py sopds_util setconf SOPDS_SCAN_SHED_HOUR "11"
python3 manage.py sopds_util setconf SOPDS_LANGUAGE ru-RU
python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY True
python3 manage.py sopds_util setconf SOPDS_INPX_ENABLE True
python3 manage.py sopds_util setconf SOPDS_INPX_TEST_ZIP True
python3 manage.py sopds_util setconf SOPDS_DELETE_LOGICAL True
python3 manage.py sopds_server start & python3 manage.py sopds_scanner start
