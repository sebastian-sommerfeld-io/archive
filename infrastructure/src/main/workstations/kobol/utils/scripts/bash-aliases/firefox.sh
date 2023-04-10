#!/bin/bash
# @file run-tests.sh
# @brief Open Firefox from command line.
#
# @description Start Firefox and open a set of tabs. The bash alias ``ff`` calls this script.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Start Firefox"

firefox \
    -new-tab -url https://mail.google.com \
    -new-tab -url https://calendar.google.com \
    -new-tab -url https://web.whatsapp.com \
    &
