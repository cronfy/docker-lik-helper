#!/usr/bin/env bash

cd `dirname $0`

PROJECT_ROOT="$1"
LOCAL_DOCKER_RELATIVE="$2"

[ -z "$PROJECT_ROOT" ] && {
    echo "Project root must be passed as first argument"
    exit 1
}

[ -z "$LOCAL_DOCKER_RELATIVE" ] && {
    echo "Relative path to deploy/docker root must be passed as second argument"
    exit 1
}

./load-mysql-dump.sh $PROJECT_ROOT $LOCAL_DOCKER_RELATIVE &&

# project root
cd "$PROJECT_ROOT" &&

./yii user/create admin@example.com admin admin1 root &&
./yii user/password admin admin