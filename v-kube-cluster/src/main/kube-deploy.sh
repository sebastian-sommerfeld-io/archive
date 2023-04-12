#!/bin/bash

(
  cd kube-cluster || exit

  echo -e "$LOG_INFO ------------------------------------------------------------------"
  echo -e "$LOG_INFO Start Deployments"
  echo -e "$LOG_INFO ------------------------------------------------------------------"

  bash deploy/dashboard.sh
  bash deploy/metrics-server.sh

  ################################################################################
  #    All deployments done                                                      #
  ################################################################################
)
