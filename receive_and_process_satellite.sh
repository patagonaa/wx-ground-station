#!/bin/bash

SAT=$1
FREQ=$2
FILEKEY=$3
TLE_FILE=$4
START_TIME=$5
END_TIME=$6
DURATION=$7
ELEVATION=$8
DIRECTION=$9

source ./config.env

AUDIO_DIR=${OUT_DIR}/audio
LOG_DIR=${OUT_DIR}/logs
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log

mkdir -p $AUDIO_DIR
mkdir -p $LOG_DIR

echo $@ >> $LOGFILE

echo actual start time: `date +%s` >> $LOGFILE
echo duration: $DURATION >> $LOGFILE

#/usr/local/bin/rtl_biast -b 1 2>> $LOGFILE
timeout -k 30s $DURATION rtl_fm -f ${FREQ}M -s 60k -E wav $SDR_FM_ARGS - 2>> $LOGFILE | sox -t wav - $AUDIO_FILE rate 11025
#/usr/local/bin/rtl_biast -b 0 2>> $LOGFILE

echo actual end time: `date +%s` >> $LOGFILE

if [ -e $AUDIO_FILE ]
  then
    ./process_satellite.sh $FILEKEY $START_TIME $END_TIME "$SAT" $ELEVATION $TLE_FILE
    ./upload.sh $FILEKEY >> $LOGFILE 2>&1
fi
