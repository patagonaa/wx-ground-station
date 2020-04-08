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
IMAGE_DIR=${OUT_DIR}/images
META_DIR=${OUT_DIR}/meta
LOG_DIR=${OUT_DIR}/logs
MAP_FILE=${IMAGE_DIR}/${FILEKEY}-map.png
AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
LOGFILE=${LOG_DIR}/${FILEKEY}.log
METAFILE=${META_DIR}/${FILEKEY}.txt

mkdir -p $AUDIO_DIR
mkdir -p $IMAGE_DIR
mkdir -p $META_DIR
mkdir -p $LOG_DIR

echo $@ >> $LOGFILE

echo Working Directory: $PWD >> $LOGFILE

#/usr/local/bin/rtl_biast -b 1 2>> $LOGFILE
sudo timeout $DURATION rtl_fm -f ${FREQ}M -s 60k -g $SDR_GAIN -p 0 -E wav -F 9 - 2>> $LOGFILE | sox -t wav - $AUDIO_FILE rate 11025
#/usr/local/bin/rtl_biast -b 0 2>> $LOGFILE

PassStart=`expr $START_TIME + 90`

if [ -e $AUDIO_FILE ]
  then
    wxmap -T "${SAT}" -H $TLE_FILE -p 0 -l 0 -o $PassStart ${MAP_FILE} >> $LOGFILE 2>&1
    echo RAW >> $LOGFILE
    wxtoimg -m ${MAP_FILE} $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-RAW.png >> $LOGFILE 2>&1
    echo ZA >> $LOGFILE
    wxtoimg -m ${MAP_FILE} -e ZA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-ZA.png >> $LOGFILE 2>&1
    echo NO >> $LOGFILE
    wxtoimg -m ${MAP_FILE} -e NO $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-NO.png >> $LOGFILE 2>&1
    echo MSA >> $LOGFILE
    wxtoimg -m ${MAP_FILE} -e MSA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA.png >> $LOGFILE 2>&1
    echo MCIR >> $LOGFILE
    wxtoimg -m ${MAP_FILE} -e MCIR $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MCIR.png >> $LOGFILE 2>&1
    echo THERM >> $LOGFILE
    wxtoimg -m ${MAP_FILE} -e therm $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-THERM.png >> $LOGFILE 2>&1

    TLE1=`grep "$SAT" $TLE_FILE -A 2 | tail -2 | head -1 | tr -d '\r'`
    TLE2=`grep "$SAT" $TLE_FILE -A 2 | tail -2 | tail -1 | tr -d '\r'`
    GAIN=`grep Gain $LOGFILE | head -1`
    CHAN_A=`grep "Channel A" $LOGFILE | head -1`
    CHAN_B=`grep "Channel B" $LOGFILE | head -1`

    echo START_TIME=$START_TIME > $METAFILE
    echo TLE1=$TLE1 >> $METAFILE
    echo TLE2=$TLE2 >> $METAFILE
    echo GAIN=$GAIN >> $METAFILE
    echo CHAN_A=$CHAN_A >> $METAFILE
    echo CHAN_B=$CHAN_B >> $METAFILE
    echo MAXELEV=$ELEVATION >> $METAFILE

    ./upload.sh $FILEKEY >> $LOGFILE 2>&1
fi
