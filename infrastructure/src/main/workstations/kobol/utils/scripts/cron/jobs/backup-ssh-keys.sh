#!/bin/bash
# @file backup-ssh.keys.sh
# @brief Backup ssh keys to USB drive
#
# @description The script copies a bunch of ssh keys to a certain USB device. It is invoked regularly by cron.
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
  echo "[backup-ssh-keys]   "
}


{
  USB_DIR="/media/$USER/USB-1TB/.kobol-backups/.ssh"
  SSH_DIR="$HOME/.ssh"


  echo -e "$LOG_INFO $(log_time) $(log_script) Ensure $USB_DIR exists"
  mkdir -p "$USB_DIR"


  echo -e "$LOG_INFO $(log_time) $(log_script) Backup all SSH keys, known_hosts and config from $USB_DIR to $SSH_DIR"
  if [ -d "$USB_DIR" ]; then
    echo -e "$LOG_INFO $(log_time) $(log_script) Backup keys from $SSH_DIR to $USB_DIR"

    rm -rf "${USB_DIR:?}/*"
    cp -a "$SSH_DIR/." "$USB_DIR"

    echo -e "$LOG_DONE $(log_time) $(log_script) Keys backup finished"
  else
    echo -e "$LOG_ERROR $(log_time) $(log_script) Directory on USB drive '$USB_DIR' not accessible"
    echo -e "$LOG_ERROR $(log_time) $(log_script) No SSH keys copied"
  fi
} >> "$LOG"
