#!/bin/bash

source ./config.env

shopt -s nullglob

echo starting upload

curl --silent --fail --show-error -T ${OUT_DIR}/upcoming_passes.txt ${WEBDAV_URL}/upcoming_passes.txt

for f in ${OUT_DIR}/meta/*; do
  echo $f
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/meta/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/images/*; do
  echo $f
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/images/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/audio/*; do
  echo $f
  curl --silent --fail --show-error -T $f ${WEBDAV_URL}/audio/`basename -- $f` && rm $f
done
