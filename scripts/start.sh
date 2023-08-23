#!/bin/bash

python3 manage.py sopds_util setconf SOPDS_ROOT_LIB $SOPDS_ROOT_LIB
python3 manage.py sopds_util setconf SOPDS_INPX_ENABLE $SOPDS_INPX_ENABLE
python3 manage.py sopds_util setconf SOPDS_LANGUAGE $SOPDS_LANGUAGE

#configure fb2converter for epub and mobi - https://github.com/rupor-github/fb2converter
python3 manage.py sopds_util setconf SOPDS_FB2TOEPUB "convert/fb2c/fb2epub"
python3 manage.py sopds_util setconf SOPDS_FB2TOMOBI "convert/fb2c/fb2mobi"

#autocreate the superuser
if [[ ! -z $SOPDS_SU_NAME && ! -z $SOPDS_SU_EMAIL &&  ! -z $SOPDS_SU_PASS ]]
then
expect /sopds/superuser.exp
fi

#To start the Telegram-bot if it enabled
if [ $SOPDS_TMBOT_ENABLE == True ]
then
python3 manage.py sopds_telebot start --daemon
fi

python3 manage.py sopds_server start & python3 manage.py sopds_scanner start
