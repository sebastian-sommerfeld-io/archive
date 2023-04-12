#!/bin/bash

host="$1" # hostname of vagrant box

################################################################################

if [ -z "$host" ]
then
  echo -e "$LOG_ERROR Param missing: hostname of vagrant box (string)"
  echo -e "$LOG_ERROR exit"
  exit 0
fi

################################################################################

(
  cd kube-cluster || exit
  vagrant ssh "$1"
)
