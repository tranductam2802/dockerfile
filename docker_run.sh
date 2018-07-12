#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname ${0}); pwd)

# config
source ${SCRIPT_DIR}/config.local.sh
source ${SCRIPT_DIR}/config.sh

# generate docker-compose.yml
DOCKER_COMPOSE_TEMPLATE_PATH=${SCRIPT_DIR}/docker-setup/docker-compose.template
DOCKER_COMPOSE_PATH=${SCRIPT_DIR}/docker-setup/docker-compose.yml
printf "cat << __EOF__\n$(cat ${DOCKER_COMPOSE_TEMPLATE_PATH})\n__EOF__" | bash > ${DOCKER_COMPOSE_PATH}

# up
docker-compose -f ${DOCKER_COMPOSE_PATH} up

# clean up
printf "\n" | yes | docker-compose -f ${DOCKER_COMPOSE_PATH} rm
rm ${DOCKER_COMPOSE_PATH}
