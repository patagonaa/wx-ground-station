#!/bin/bash

currentDir=`echo $PWD`
echo "configuring for" $currentDir

chmod +x schedule_all.sh
chmod +x schedule_satellite.sh
chmod +x receive_and_process_satellite.sh

cronjobcmd="bash -lc 'cd $currentDir && ./schedule_all.sh'"
cronjob="0 0 * * * $cronjobcmd"
( crontab -l | grep -v -F "$cronjobcmd" ; echo "$cronjob" ) | crontab -
