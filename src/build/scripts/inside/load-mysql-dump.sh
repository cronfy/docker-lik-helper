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

cd "$PROJECT_ROOT"

. .env

if [ -e $LOCAL_DOCKER_RELATIVE/build/data/user/db.sql.gz ] ; then
    echo Using user dump
    dump=$LOCAL_DOCKER_RELATIVE/build/data/user/db.sql.gz
else
    echo Using initial dump
    dump=$LOCAL_DOCKER_RELATIVE/build/data/initial/db.sql.gz
fi

mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "DROP DATABASE $DB_NAME; CREATE DATABASE $DB_NAME;" &&
zcat $dump | mysql -u "$DB_USER" -p"$DB_PASS" "$DB_NAME"

