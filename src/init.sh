
[ -z "$LOCAL_DOCKER" ] && {
    echo "LOCAL_DOCKER environment variable required, but not set. Aborting." >&2
    exit 1
}

. "$LOCAL_DOCKER/variables.sh"

function requireVariables() {
    local passed=yes

    for name in "$@" ; do
        [ -z "${!name}" ] && {
            error Variable $name required, but not set.
            passed=no
        }
    done

    [ "yes" == "$passed" ]
}

function error() {
    echo "$@" >&2
}

function checkUserdata() {
    local OK=1

    [ -e "$LOCAL_DOCKER/$DB_DUMP_USER" ] || [ -e "$LOCAL_DOCKER/$DB_DUMP_INITIAL" ] || {
        echo "DB dump not found in $LOCAL_DOCKER/$DB_DUMP_USER or $LOCAL_DOCKER/$DB_DUMP_INITIAL" >&2
        OK=0
    }

    [ -e "$LOCAL_DOCKER/$SSH_KEY" ] || {
        echo "SSH key not found in $LOCAL_DOCKER/$SSH_KEY" >&2
        OK=0
    }

    [ "1" = "$OK" ]

}

function wwwExec() {
    docker exec -u www-data $PROJECT_NAME bash -l -c "$@"
}

requireVariables PROJECT_DIR PROJECT_NAME MYSQL_PASSWORD CONTAINER_IP || {
    error "Not all variables are set."
    exit 1
}

cd $LOCAL_DOCKER/$PROJECT_DIR
PROJECT_DIR="`pwd`"
LOCAL_DOCKER_RELATIVE="`realpath --relative-to="$PROJECT_DIR" "$LOCAL_DOCKER"`"

requireVariables LOCAL_DOCKER_RELATIVE || {
    error "Failed to detect relative local docker path - realpath not installed?"
    exit 1
}

: ${CANONICAL_HOST:=$PROJECT_NAME.dev.loc}
: ${DB_DUMP_USER:=build/data/user/db.sql.gz}
: ${DB_DUMP_INITIAL:=build/data/initial/db.sql.gz}
: ${SSH_KEY:=build/data/user/id_rsa}
: ${NETWORK_NAME:=cronfy-network}
: ${NETWORK_SUBNET:=172.22.176.0/24}
: ${NETWORK_IP_RANGE:=172.22.176.240/28}
: ${NETWORK_NAME:=cronfy-network}

CONTAINER_PROJECT_DIR=/app

checkUserdata || {
    error Fatal error.
    exit 1
}