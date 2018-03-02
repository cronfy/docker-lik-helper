#!/usr/bin/env bash

cd `dirname $0` ; WDIR="`pwd`" ; cd ../.. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

echo -e "\n***"
echo "* TWEAKING UID"
echo -e "***\n"

docker exec $PROJECT_NAME usermod -u $UID www-data &&
docker exec $PROJECT_NAME chown -R www-data /app &&
docker exec $PROJECT_NAME chown -R www-data /var/www

