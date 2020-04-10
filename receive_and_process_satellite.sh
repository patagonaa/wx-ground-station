#!/bin/bash

SAT=$1
FREQ=$2
FILEKEY=$3
TLE_FILE=$4
START_TIME=$5
DURATION=$6
ELEVATION=$7
DIRECTION=$8

source ./config.env

AUDIO_DIR=${OUT_DIR}/audio
LOG_DIR=${OUT_DIR}/logs
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log

mkdir -p $AUDIO_DIR
mkdir -p $LOG_DIR

echo $@ >> $LOGFILE

#/usr/local/bin/rtl_biast -b 1 2>> $LOGFILE
sudo timeout $DURATION rtl_fm -f ${FREQ}M -s 60k -E wav $SDR_FM_ARGS - 2>> $LOGFILE | sox -t wav - $AUDIO_FILE rate 11025
#/usr/local/bin/rtl_biast -b 0 2>> $LOGFILE

if [ -e $AUDIO_FILE ]
  then
    ./process_satellite.sh $FILEKEY $START_TIME $SAT $ELEVATION
    ./upload.sh $FILEKEY >> $LOGFILE 2>&1
fi
