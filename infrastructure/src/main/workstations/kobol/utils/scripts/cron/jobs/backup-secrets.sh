#!/bin/bash
# @file backup-ssh.keys.sh
# @brief Backup secrets to USB drive
#
# @description The script copies a bunch of secrets (like certs) to a certain USB device. It is invoked regularly by cron.
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
  echo "[backup-secrets]   "
}


{
  USB_DIR="/media/$USER/USB-1TB/.kobol-backups/.secrets"
  SECRETS_DIR="$HOME/Documents/.secrets"


  echo -e "$LOG_INFO $(log_time) $(log_script) Ensure $USB_DIR exists"
  mkdir -p "$USB_DIR"


  echo -e "$LOG_INFO $(log_time) $(log_script) Backup all secrets from $USB_DIR to $SECRETS_DIR"
  if [ -d "$USB_DIR" ]; then
    echo -e "$LOG_INFO $(log_time) $(log_script) Backup secrets from $SECRETS_DIR to $USB_DIR"

    rm -rf "${USB_DIR:?}/*"
    cp -a "$SECRETS_DIR/." "$USB_DIR"

    echo -e "$LOG_DONE $(log_time) $(log_script) secrets backup finished"
  else
    echo -e "$LOG_ERROR $(log_time) $(log_script) Directory on USB drive '$USB_DIR' not accessible"
    echo -e "$LOG_ERROR $(log_time) $(log_script) No secrets keys copied"
  fi
} >> "$LOG"
