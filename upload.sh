#!/bin/bash

source ./config.env

echo starting upload
for f in ${OUT_DIR}/meta/*; do
  echo $f
  curl --silent --fail -T $f ${WEBDAV_URL}/meta/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/images/*; do
  echo $f
  curl --silent --fail -T $f ${WEBDAV_URL}/images/`basename -- $f` && rm $f
done
for f in ${OUT_DIR}/audio/*; do
  echo $f
  curl --silent --fail -T $f ${WEBDAV_URL}/audio/`basename -- $f` && rm $f
done
