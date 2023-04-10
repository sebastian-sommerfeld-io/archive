#!/bin/bash
# @file yq.sh
# @brief Wrapper to use yq from Docker container when using the ``yq`` command.
#
# @description The script is a wrapper to use yq from a Docker container when using the ``yq`` command. The script
# delegates the all tasks to the yq installation runtime inside a custom container using image.
#
# In order to use the ``yq`` command, the ``11-configure-wrappers.sh`` script adds a symlink to access this script
# via ``/usr/bin/yq``.
#
# yq a lightweight and portable command-line YAML, JSON and XML processor. For more details, see
# https://github.com/mikefarah/yq or https://mikefarah.gitbook.io/yq.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for yq inside Docker"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="mikefarah/yq"
TAG="latest"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" yq "$@"
