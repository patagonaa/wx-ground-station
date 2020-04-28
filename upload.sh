#!/bin/bash

source ./config.env

shopt -s nullglob

echo starting upload

curl --silent --fail --show-error -T ${OUT_DIR}/upcoming_passes.txt ${WEBDAV_URL}/upcoming_passes.txt

CURRENT_YEAR=`date -u +"%Y"`
CURRENT_MONTH=`date -u +"%m"`

for dir in meta images audio
do
  curl --silent -X MKCOL ${WEBDAV_URL}/${dir}/${CURRENT_YEAR} > /dev/null
  curl --silent -X MKCOL ${WEBDAV_URL}/${dir}/${CURRENT_YEAR}/${CURRENT_MONTH} > /dev/null
done

for f in ${OUT_DIR}/images/*; do
  echo $f
  FILE_YEAR=`basename -- $f | cut -c1-4`
  FILE_MONTH=`basename -- $f | cut -c5-6`
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/images/${FILE_YEAR}/${FILE_MONTH}/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/meta/*; do
  echo $f
  FILE_YEAR=`basename -- $f | cut -c1-4`
  FILE_MONTH=`basename -- $f | cut -c5-6`
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/meta/${FILE_YEAR}/${FILE_MONTH}/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/audio/*; do
  echo $f
  FILE_YEAR=`basename -- $f | cut -c1-4`
  FILE_MONTH=`basename -- $f | cut -c5-6`
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/audio/${FILE_YEAR}/${FILE_MONTH}/`basename -- $f` && rm $f
done
