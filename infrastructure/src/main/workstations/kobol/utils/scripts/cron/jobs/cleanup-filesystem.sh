#!/bin/bash
# @file cleanup-filesystem.sh
# @brief Delete unwanted files and folders from machine.
#
# @description Sometimes applications leave traces in the form of files and folders. Virtual machines running some
# Windows often leave _System Volume Information_ folders behind. This script deleted these folders and other
# blacklisted files and folders. The script is invoked hourly by cron (see xref:src_main_util_cleanup-filesystem.adoc[]).
#
# ==== Arguments
#
# The script does not accept any parameters.


LOG="$HOME/logs/cron.log"


# @description Utility function to log timestamp.
function log_time() {
  d=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$d]   "
}


# @description Utility function to log scriptname.
function log_script() {
  echo "[cleanup-filesystem]   "
}


{
  echo -e "$LOG_INFO $(log_time) $(log_script) Cleanup files and folders from blacklist for $Y'$HOME'$D"

  blacklist=(
    "System Volume Information"
    "java_error_in_idea_*.log"
    ".DS_Store"
    "firefox.tmp"
  )

  for folder in "${blacklist[@]}"
  do
    echo -e "$LOG_INFO $(log_time) $(log_script) Scan for folder $Y'$folder'$D"
    result=$(find "$HOME" -name "$folder")

    if [ -z "$result" ]
    then
      echo -e "$LOG_INFO $(log_time) $(log_script) No results found"
    else
      # iterate multiline string
      while IFS= read -r line
      do
        echo -e "$LOG_INFO $(log_time) $(log_script) Remove $line"
        rm -rf "$line"
      done <<< "$result"
    fi

  done

  echo -e "$LOG_DONE $(log_time) $(log_script) Cleanup complete"
} >> "$LOG"
