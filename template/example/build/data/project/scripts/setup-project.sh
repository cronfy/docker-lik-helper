#!/usr/bin/env bash

cd `dirname $0` ; WDIR="`pwd`"

DOCKER_HELPER="$1"

[ -z "$DOCKER_HELPER" ] && {
    echo "Project root must be passed as first argument"
    exit 1
}

. "$DOCKER_HELPER"/init.sh

echo -e "\n***"
echo "* PROJECT OWN SETUP"
echo -e "***\n"

wwwExec "$LOCAL_DOCKER_RELATIVE/build/data/project/scripts/inside/deploy-data.sh $CONTAINER_PROJECT_DIR $LOCAL_DOCKER_RELATIVE" &&

true

