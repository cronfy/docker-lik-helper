#!/usr/bin/env bash

cd `dirname $0`
cd ../

if [ ! -d helper ] ; then
    git clone https://github.com/cronfy/docker-lik-helper helper || {
        # rm -rf helper
        echo "Failed to get build helper" >&2
        exit 1
    }
fi

LOCAL_DOCKER="`pwd`" ./helper/src/build/build.sh "$@"
