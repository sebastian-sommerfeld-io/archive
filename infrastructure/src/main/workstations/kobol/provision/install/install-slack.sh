#!/bin/bash
# @file install-slack.sh
# @brief Install Slack.
#
# @description The script downloads and installs Slack.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install slack"
sudo snap install slack
echo -e "$LOG_DONE Installed slack"
