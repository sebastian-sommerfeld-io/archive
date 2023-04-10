#!/bin/bash
# @file connect.sh
# @brief Connect to Vagrantbox pegasus via ssh.
#
# @description The script establishes a ssh connection to the Vagrantbox.
#
# === Script Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Establish ssh connection"
vagrant ssh
