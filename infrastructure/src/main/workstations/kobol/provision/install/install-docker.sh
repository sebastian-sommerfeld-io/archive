#!/bin/bash
# @file install-docker.sh
# @brief Install docker and docker compose.
#
# @description The script installs docker and docker compose.
# For installation instructions, see https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Uninstall old docker versions"
sudo apt-get remove -y docker docker.io containerd runc

echo -e "$LOG_INFO Install docker using the convenience script"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo bash get-docker.sh
rm get-docker.sh
echo -e "$LOG_DONE Installed docker"

# echo -e "$LOG_INFO Install docker"
# sudo apt-get install -y docker.io
# sudo apt-get install -y docker compose
# #sudo groupadd docker
# sudo usermod -aG docker "$USER"
# #newgrp docker
# echo -e "$LOG_DONE Installed docker"
