#!/bin/bash
# @file clean.sh
# @brief Remove Vagrantbox pegasus.
#
# @description The script removes Vagrantbox and cleans up the filesystem leaving no trace of the virtual machine setup
# behind. Run ``stop.sh`` first before cleaning up.
#
# === Script Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Remove all virtual machines"
vagrant destroy -f

echo -e "$LOG_INFO Cleanup filesystem (.vagrant and target folders)"
rm -rf .vagrant
rm -rf ./*.log
rm -rf ../../../target/*

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Cleanup complete"
echo -e "$LOG_DONE ------------------------------------------------------------------"
