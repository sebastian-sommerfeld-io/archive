#!/bin/bash
# @file jq.sh
# @brief Wrapper to use jq from Docker container when using the ``jq`` command.
#
# @description The script is a wrapper to use jq from a Docker container when using the ``jq`` command. The script
# delegates the all tasks to the jq installation runtime inside a custom container using image.
#
# In order to use the ``jq`` command, the ``11-configure-wrappers.sh`` script adds a symlink to access this script
# via ``/usr/bin/jq``.
#
# jq is a lightweight and flexible command-line JSON processor. For more details, see https://stedolan.github.io/jq.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for jq inside Docker"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="sommerfeldio/jq"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" jq "$@"
