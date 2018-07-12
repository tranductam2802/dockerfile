#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname ${0}); pwd)

# config
source ${SCRIPT_DIR}/config.local.sh
source ${SCRIPT_DIR}/config.sh

# ssh
KEY_PATH=${SCRIPT_DIR}/docker-setup/ssh_key
AUTHORIZED_KEY_PATH=${SCRIPT_DIR}/docker-setup/authorized_keys
printf "\n\n\n" | yes y | ssh-keygen -t rsa -N "" -f ${KEY_PATH}
cat ${KEY_PATH}.pub > ${AUTHORIZED_KEY_PATH}

# docker build
docker build -t ${DOCKER_IMAGE_NAME} \
    --build-arg HTTP_PROXY=${HTTP_PROXY} \
    --build-arg HTTPS_PROXY=${HTTPS_PROXY} \
    --build-arg CONTAINER_USER_NAME=${CONTAINER_USER_NAME} \
    --build-arg CONTAINER_PASSWORD=${CONTAINER_PASSWORD} \
    --build-arg CONTAINER_UID=${CONTAINER_UID} \
    --build-arg CONTAINER_GID=${CONTAINER_GID} \
    ${SCRIPT_DIR}/docker-setup
