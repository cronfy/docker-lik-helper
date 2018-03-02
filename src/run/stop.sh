#!/usr/bin/env bash

cd `dirname $0` ; cd .. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

docker stop $PROJECT_NAME


