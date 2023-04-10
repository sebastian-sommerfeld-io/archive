#!/bin/bash
# @file stop.sh
# @brief Stop Vagrantbox pegasus.
#
# @description The scripts gracefully stops Vagrantbox.
#
# === Script Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Shutting down Vagrant Boxes"
vagrant halt

echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE All Vagrant Boxes are shut down"
echo -e "$LOG_DONE ------------------------------------------------------------------"
