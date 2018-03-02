#!/usr/bin/env bash

cd `dirname $0` ; cd .. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

docker exec -ti -u www-data $PROJECT_NAME bash -l
