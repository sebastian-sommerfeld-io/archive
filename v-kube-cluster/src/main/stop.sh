#!/bin/bash

(
  echo -e "$LOG_INFO Shutting down Vagrant Boxes"
  cd kube-cluster || exit
  vagrant halt
)

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE All Vagrant Boxes are shut down"
echo -e "$LOG_DONE ------------------------------------------------------------------"
