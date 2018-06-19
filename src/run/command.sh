#!/usr/bin/env bash

cd $(dirname $0) ; cd .. ; RDIR="$(pwd)" ; . "$RDIR/init.sh"

docker exec "$PROJECT_NAME" su - www-data -s /bin/bash -c "$*"

