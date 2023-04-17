#!/bin/bash
# @file scale-down.sh
# @brief Scale down mp4 video files.
#
# @description The script scales down mp4 video files.
# See https://askubuntu.com/questions/923882/reducing-filesize-of-video-in-ubuntu
#
# === Script Arguments
#
# * *$1* (string): The file to scale down. Should be in the same directory as this script.
#
# === Script Example
#
# [source, bash]
# ```
# ./scale-down.sh some-video.mp4
# ```


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


echo -e "$LOG_INFO ------------------------------------------------------------------"
echo -e "$LOG_INFO Start scaling down"
echo -e "$LOG_INFO ------------------------------------------------------------------"


readonly IN="$1"
readonly OUT="SCALED $IN"


if [ -z "$IN" ]
then
  echo -e "$LOG_ERROR Param missing: 'IN' (the filename) -> String"
  echo -e "$LOG_ERROR exit"
  exit 0
fi


echo -e "$LOG_INFO Select quality factor"
echo -e "$LOG_INFO Initial value = 20"
echo -e "$LOG_INFO if size still too big and video quality still acceptable incrementally increase"


select quality in 20 24 28 32 36 40; do

  echo
  echo -e "$LOG_INFO      in = $IN"
  echo -e "$LOG_INFO     out = $OUT"
  echo -e "$LOG_INFO quality = $quality"
  echo

  time ffmpeg -i "$IN" -c:v libx264 -preset slow -crf "$quality" -c:a copy "$OUT"

  echo
  echo -e "$LOG_DONE ------------------------------------------------------------------"
  echo -e "$LOG_DONE Finished scaling down"
  echo -e "$LOG_DONE      in = $IN"
  echo -e "$LOG_DONE     out = $OUT"
  echo -e "$LOG_DONE quality = $quality"
  echo -e "$LOG_DONE ------------------------------------------------------------------"

  break
done
