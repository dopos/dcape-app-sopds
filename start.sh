#!/usr/bin/env bash
set -e

serverPID=0
scannerPID=0
botPID=0
stopFlag=0
echo "Setup: $DB_HOST -U $DB_USER -d $DB_NAME"

HASTABLES=$(PGPASSWORD=$DB_PASS psql -tA -h $DB_HOST -U $DB_USER -d $DB_NAME -c '\dt')

if [ -z "$HASTABLES" ] ; then
    python3 manage.py migrate
    expect /sopds/superuser.exp
    python3 manage.py sopds_util clear
    cat /genre.sql | PGPASSWORD=$DB_PASS psql -tA -h $DB_HOST -U $DB_USER -d $DB_NAME
    python3 manage.py sopds_scanner scan
fi

python3 manage.py sopds_util setconf SOPDS_ROOT_LIB $SOPDS_ROOT_LIB
python3 manage.py sopds_util setconf SOPDS_INPX_ENABLE $SOPDS_INPX_ENABLE
python3 manage.py sopds_util setconf SOPDS_LANGUAGE $SOPDS_LANGUAGE

#configure fb2converter for epub and mobi - https://github.com/rupor-github/fb2converter
python3 manage.py sopds_util setconf SOPDS_FB2TOEPUB "convert/fb2c/fb2epub"
python3 manage.py sopds_util setconf SOPDS_FB2TOMOBI "convert/fb2c/fb2mobi"

app_stop() {
  local name=$1
  local pid=$2
  if [ $pid -ne 0 ]; then
    kill -TERM "$pid"
    echo "$name application terminated…"
    wait "$pid"
  fi
}

sigterm_handler() {
  echo "sigterm handler called…"
  app_stop "bot" $botPID
  app_stop "scanner" $scannerPID
  app_stop "server" $serverPID
  stopFLag=1
  exit 143;
}

trap 'kill ${!}; sigterm_handler' TERM

#To start the Telegram-bot if it enabled
if [ $SOPDS_TMBOT_ENABLE == True ] ; then
  python3 manage.py sopds_telebot start --daemon
  botPID="$!"
fi

python3 manage.py sopds_server start &
serverPID="$!"
python3 manage.py sopds_scanner start &
scannerPID="$!"

# wait forever
while true ; do
  tail -f /dev/null & wait ${!}
done
