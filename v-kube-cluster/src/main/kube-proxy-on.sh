#!/bin/bash

echo -e "$LOG_INFO ------------------------------------------------------------------"
echo -e "$LOG_INFO Start kubectl proxy"
echo -e "$LOG_INFO Proxy NOT running in background !!"
echo -e "$LOG_INFO ------------------------------------------------------------------"

(
  cd kube-cluster || exit
  vagrant ssh v-k8s-master -c "kubectl proxy --address='0.0.0.0' --port=8001 --accept-hosts='.*'"
)
