#!/bin/bash

echo -e "$LOG_INFO Start Vagrant Boxes"

(
  cd kube-cluster || exit
  vagrant up
)

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE All Vagrant Boxes up and running"
echo -e "$LOG_DONE ------------------------------------------------------------------"
