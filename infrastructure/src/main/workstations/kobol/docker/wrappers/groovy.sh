#!/bin/bash
# @file groovy.sh
# @brief Wrapper to use Groovy from Docker container when using the default ``groovy`` command.
#
# @description The script is a wrapper to use Groovy from a Docker container when using the default ``groovy`` command.
# The script delegates the all tasks to the Groovy runtime inside a container using image
# ``link:https://hub.docker.com/_/groovy[groovy]``.
#
# image::https://raw.githubusercontent.com/docker-library/docs/bb5fc730ed18c45d86425f9fa4265d50cb795ec8/groovy/logo.png[]
#
# In order to use the ``groovy`` command, the ``11-configure-wrappers.sh`` script adds a symlink to access this script
# via ``/usr/bin/groovy``.
#
# ==== Arguments
#
# * *$@* (array): Original arguments


echo -e "$LOG_INFO Using the wrapper for Groovy inside Docker"
echo -e "$LOG_INFO Working dir = $(pwd)"

IMAGE="groovy"
TAG="4.0.0-jdk17"

docker run -it --rm \
  --volume "$(pwd):$(pwd)" \
  --workdir "$(pwd)" \
  "$IMAGE:$TAG" groovy "$@"
