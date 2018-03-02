#!/usr/bin/env bash

cd `dirname $0`
cd ../

LOCAL_DOCKER="`pwd`" ./helper/src/run/start.sh "$@"
