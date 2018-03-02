#!/usr/bin/env bash

cd `dirname $0` ; WDIR="`pwd`" ; cd ../.. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

echo -e "\n***"
echo "* INITIALIZING SSH AGENT"
echo -e "***\n"

echo -e "\n*\n*\n*\n*\n"
echo "SSH key required to proceed with installation. Please enter passphrase if you are using it."
echo -e "\n*\n*\n*\n*\n"

docker exec -u www-data -ti $PROJECT_NAME bash -l -c ssh-add

