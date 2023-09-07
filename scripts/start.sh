#!/bin/bash
DB
cd /sopds
if [ $MIGRATE == True ]; then
python3 manage.py migrate
fi
if [ $DBCLEAR == True ]; then
python3 manage.py sopds_util clear
fi
#autocreate the superuser
if [[ ! -z $SOPDS_SU_NAME && ! -z $SOPDS_SU_EMAIL &&  ! -z $SOPDS_SU_PASS ]]; then
expect /sopds/superuser.exp
fi
python3 manage.py sopds_util setconf SOPDS_AUTH False
python3 manage.py sopds_util setconf SOPDS_SCAN_SHED_HOUR "11"
# python3 manage.py sopds_util setconf SOPDS_LANGUAGE ru-RU
python3 manage.py sopds_util setconf SOPDS_SCAN_START_DIRECTLY True
python3 manage.py sopds_util setconf SOPDS_INPX_ENABLE True
python3 manage.py sopds_server start & python3 manage.py sopds_scanner start
