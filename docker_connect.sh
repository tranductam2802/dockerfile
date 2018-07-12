#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname ${0}); pwd)

# config
source ${SCRIPT_DIR}/config.sh

# connect
ssh ${CONTAINER_USER_NAME}@0.0.0.0 -p ${MASTER_SSH_PORT} -v -i ${SCRIPT_DIR}/docker-setup/ssh_key
