#!/bin/bash

echo -e "$LOG_INFO Remove all virtual machines created for the kubernetes cluster"
(
  cd kube-cluster || exit
  vagrant destroy -f
)

echo -e "$LOG_INFO Cleanup filesystem"
rm -rf kube-cluster/.vagrant
rm -rf ../../target/*

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Cleanup complete"
echo -e "$LOG_DONE ------------------------------------------------------------------"
