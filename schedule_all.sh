#!/bin/bash

source ./config.env

mkdir -p $OUT_DIR

# Update Satellite Information

wget -qr https://www.celestrak.com/NORAD/elements/weather.txt -O ${OUT_DIR}/weather.txt
grep "NOAA 15" ${OUT_DIR}/weather.txt -A 2 > ${OUT_DIR}/weather.tle
grep "NOAA 18" ${OUT_DIR}/weather.txt -A 2 >> ${OUT_DIR}/weather.tle
grep "NOAA 19" ${OUT_DIR}/weather.txt -A 2 >> ${OUT_DIR}/weather.tle

#Remove all AT jobs

for i in `atq | awk '{print $1}'`;do atrm $i;done

rm -f ${OUT_DIR}/upcoming_passes.txt

#Schedule Satellite Passes:

./schedule_satellite.sh "NOAA 19" 137.1000
./schedule_satellite.sh "NOAA 18" 137.9125
./schedule_satellite.sh "NOAA 15" 137.6200

# upcoming_passes.txt could be uploaded somewhere here
#  ${OUT_DIR}/upcoming_passes.txt

