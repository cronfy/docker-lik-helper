#!/usr/bin/env bash

cd `dirname $0` ; cd .. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

if [[ "$(docker images -q image-$PROJECT_NAME 2> /dev/null)" == "" ]]; then
    cp $RDIR/build/Dockerfile $LOCAL_DOCKER/build/
    docker build -t image-$PROJECT_NAME --build-arg MYSQL_USER_PASS="$MYSQL_PASSWORD" $LOCAL_DOCKER/build &&
    $RDIR/build/scripts/first-run.sh &&
    $RDIR/run/start.sh
else
    echo "ERROR: Image already exists, please run destroy.sh if you want to start a new build." >&2
    exit 1
fi

