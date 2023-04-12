#!/bin/bash

# load common vars (../ just once due to cd in script calling this deploy script)
# shellcheck disable=SC1091
source ../vars.sh

################################################################################
#    metrics-server                                                            #
################################################################################

echo -e "$LOG_INFO Start deployment of application: metrics-server"
echo -e "$LOG_INFO Start deployment"
vagrant ssh "${k8s_master_node:?}" -c 'kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml'
echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Deployed application: metrics-server"
echo -e "$LOG_DONE ------------------------------------------------------------------"
