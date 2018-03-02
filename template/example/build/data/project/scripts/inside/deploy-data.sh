#!/usr/bin/env bash

cd `dirname $0`

PROJECT_ROOT="$1"

[ -z "$PROJECT_ROOT" ] && {
    echo "Project root must be passed as first argument"
    exit 1
}

cd "$PROJECT_ROOT" &&
    echo "Doing something important..." && date &&

true

