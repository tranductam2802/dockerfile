#!/usr/bin/env bash
SCRIPT_DIR=$(cd $(dirname ${0}); pwd)

# Docker Image
export DOCKER_IMAGE_NAME=demo

# Host name
export MASTER_HOSTNAME=u-demo-master

# Port (in container: 22)
export MASTER_SSH_PORT=1234

# file share (in host path)
export MASTER_DEMO_PROJECT=${SCRIPT_DIR}/share/master/demo_project

# Resource (Master)
export MASTER_MIN_CPU=0.0001
export MASTER_MAX_CPU=0.001
export MASTER_MIN_MEM=20M
export MASTER_MAX_MEM=50M

# User (in container)
export CONTAINER_USER_NAME=demo_user
export CONTAINER_PASSWORD=demo_password

# UID/GID (for file share)
export CONTAINER_UID=$(id -u)
export CONTAINER_GID=$(id -g)
