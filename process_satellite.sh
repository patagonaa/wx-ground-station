#!/bin/bash

FILEKEY=$1
START_TIME=$2
SAT=$3
ELEVATION=$4
TLE_FILE=$5

source ./config.env

IMAGE_DIR=${OUT_DIR}/images
META_DIR=${OUT_DIR}/meta
AUDIO_DIR=${OUT_DIR}/audio
LOG_DIR=${OUT_DIR}/logs

AUDIO_FILE=${AUDIO_DIR}/${FILEKEY}.wav
MAP_FILE=${IMAGE_DIR}/${FILEKEY}-map.png
METAFILE=${META_DIR}/${FILEKEY}.txt
LOGFILE=${LOG_DIR}/${FILEKEY}.log

mkdir -p $LOG_DIR
mkdir -p $IMAGE_DIR
mkdir -p $META_DIR

PassStart=`expr $START_TIME + 90`

wxmap -T "${SAT}" -H $TLE_FILE -p 0 -l 0 -o $PassStart ${MAP_FILE} >> $LOGFILE 2>&1
echo RAW >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-RAW.png >> $LOGFILE 2>&1
echo ZA >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS -e ZA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-ZA.png >> $LOGFILE 2>&1
echo NO >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS -e NO $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-NO.png >> $LOGFILE 2>&1
echo MSA >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS -e MSA $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MSA.png >> $LOGFILE 2>&1
echo MCIR >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS -e MCIR $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-MCIR.png >> $LOGFILE 2>&1
echo THERM >> $LOGFILE
wxtoimg -m ${MAP_FILE} $WXTOIMG_ARGS -e therm $AUDIO_FILE ${IMAGE_DIR}/${FILEKEY}-THERM.png >> $LOGFILE 2>&1

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