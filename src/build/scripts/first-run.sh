#!/usr/bin/env bash

cd `dirname $0` ; WDIR="`pwd`" ; cd ../.. ; RDIR="`pwd`" ; . "$RDIR/init.sh"

showFail() {
    (
    echo -e "\n*\n*\n*\n*\n"
    echo "FAILED TO SETUP $1"
    echo -e "\n*\n*\n*\n*\n"
    ) >&2
}

echo -e "\n***"
echo "* INITIALIZING NETWORK"
echo -e "***\n"

docker network inspect $NETWORK_NAME > /dev/null || {
    docker network create --subnet $NETWORK_SUBNET --ip-range $NETWORK_IP_RANGE $NETWORK_NAME || {
        showFail network
        echo FATAL ERROR >&2
        exit 1
    }
}

echo -e "\n***"
echo "* INITIALIZING CONTAINER"
echo -e "***\n"

#
# Если контейнер уже создан
# docker network connect --ip $CONTAINER_IP $NETWORK_NAME $PROJECT_NAME

docker run -d --network=$NETWORK_NAME --ip=$CONTAINER_IP -h $CANONICAL_HOST -v $PROJECT_DIR:/app --name $PROJECT_NAME image-$PROJECT_NAME || {
    echo "FAILED to create new container \"$PROJECT_NAME\". Contaainer must NOT already exist." >&2
    exit 1
}

$WDIR/setup-ssh-agent.sh || {
    showFail ssh-agent
    echo FATAL ERROR >&2
    exit 1
}

STATUS_UID=FAIL
$WDIR/setup-uid.sh && STATUS_UID=yes

{
    STATUS_PROJECT=FAIL
    $WDIR/setup-project.sh "$CANONICAL_HOST" && STATUS_PROJECT=yes
}

{
    STATUS_PROJECT_LOCAL="not applicable"
    [ -e "$LOCAL_DOCKER/build/data/project/scripts/setup-project.sh" ] && {
        STATUS_PROJECT_LOCAL=FAIL
        $LOCAL_DOCKER/build/data/project/scripts/setup-project.sh $RDIR && STATUS_PROJECT_LOCAL=yes
    }
}

echo -e "\n***"
echo "* STARTUP LOGS"
echo -e "***\n"

docker logs $PROJECT_NAME

echo -e "\n***"
echo "* INFO"
echo -e "***\n"

echo -n "Ip Address: "
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $PROJECT_NAME
echo -n "Host: $CANONICAL_HOST"

echo
echo "Admin login/password: admin/admin"
echo

echo -e "\n***"
echo "* STATUS"
echo -e "***\n"

echo "UID changed: $STATUS_UID"
echo "Project deployed: $STATUS_PROJECT"
echo "Project own settings applied: $STATUS_PROJECT_LOCAL"

docker stop $PROJECT_NAME


