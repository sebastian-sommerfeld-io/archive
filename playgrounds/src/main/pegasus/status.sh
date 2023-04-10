#!/bin/bash
# @file status.sh
# @brief Show status for Vagrantbox pegasus.
#
# @description The script shows the status for the Vagrantbox.
#
# === Script Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Show status for Vagrantbox"
vagrant status

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Printed status information for Vagrantbox"
echo -e "$LOG_DONE ------------------------------------------------------------------"