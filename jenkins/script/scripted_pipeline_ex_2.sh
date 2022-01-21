#!/bin/sh

COMMAND='nohup python3 -u ./jenkins/script/main.py run >> py.log &'
LOGFILE=restart.txt

writelog() {
  now=`date`
  echo "$now $*" >> $LOGFILE
}

writelog "Starting"
while true ; do
  $COMMAND
  writelog "Exited with status $?"
  writelog "Restarting"
done
