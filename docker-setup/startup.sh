#!/bin/bash
# Prepare docker startup
mkdir -p ~/target/log

# Put any tasks you would like to have carried out when the container is first created here
CONTAINER_USER_NAME=${1}
MASTER_HOSTNAME=${2}
WORKER1_HOSTNAME=${3}

sudo cat << __EOF__ >> /home/${CONTAINER_USER_NAME}/.ssh/config
Host ${MASTER_HOSTNAME}
  Hostname ${MASTER_HOSTNAME}
  User ${CONTAINER_USER_NAME}
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/common_key
Host ${WORKER1_HOSTNAME}
  Hostname ${WORKER1_HOSTNAME}
  User ${CONTAINER_USER_NAME}
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/common_key

__EOF__

# Launch supervisor
sudo supervisord -c /etc/supervisor/supervisord.conf && /bin/bash
