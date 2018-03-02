#!/usr/bin/env bash

cd `dirname $0` ; WDIR="`pwd`" ; cd ../.. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

echo -e "\n***"
echo "* DEPLOYING PROJECT"
echo -e "***\n"

docker exec $PROJECT_NAME chown -R www-data /app &&

wwwExec "composer install" &&
wwwExec "php deploy/generate-basic-env.php | sed 's/^CANONICAL_HOST=.*$/CANONICAL_HOST=$CANONICAL_HOST/ ; s/^DB_PASS=.*/DB_PASS=\"$MYSQL_PASSWORD\"/' > .env" &&
wwwExec "deploy/generate-htaccess.sh > web/.htaccess" &&
wwwExec "php deploy/generate-dirs.php" &&

docker exec $PROJECT_NAME bash -c "yarn global add gulp" &&
wwwExec "yarn install" &&

wwwExec "$LOCAL_DOCKER_RELATIVE/helper/src/build/scripts/inside/deploy-data.sh $CONTAINER_PROJECT_DIR $LOCAL_DOCKER_RELATIVE" &&

true

