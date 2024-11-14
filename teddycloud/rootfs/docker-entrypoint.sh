#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

cp -r /teddycloud /data/teddycloud
mkdir -p /data/teddycloud/certs/server /data/teddycloud/certs/client

if [ -n "${DOCKER_TEST:-}" ]; then
  cd /data/teddycloud
  LSAN_OPTIONS=detect_leaks=0 teddycloud --docker-test
else
  while true
  do
    #curl -f https://raw.githubusercontent.com/toniebox-reverse-engineering/tonies-json/release/tonies.json -o /data/teddycloud/config/tonies.json || true
    cd /data//teddycloud
    teddycloud
    retVal=$?
    if [ $retVal -ne -2 ]; then
        exit $retVal
    fi
  done
fi