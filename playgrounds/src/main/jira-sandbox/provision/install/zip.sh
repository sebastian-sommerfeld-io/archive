#!/bin/bash
# @file zip.sh
# @brief Install zip and unzip.
#
# @description The script installs ``zip`` and ``unzip``.
#
# === Script Arguments
#
# The script does not accept any parameters.


echo "[INFO] Install and configure git"
sudo yum install -y zip unzip
echo "[DONE] Configured git with ssh keys"
