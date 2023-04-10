#!/bin/bash
# @file 10-configure.sh
# @brief Prepare the filesystem structure, set up aliases and variables in users .bashrc file and restore SSH keys from
# USB drive (if mounted).
#
# @description The script prepares the filesystem structure, sets up aliases and variables in users .bashrc file and
# restores SSH keys from USB drive (if mounted).
#
# * Setup aliases in users .bashrc file
# * Setup filesystem structure
# * Restore SSH keys and known_hosts from USB HDD
# * Change SSH key verification policy for IP range used by Vagrant
# * Set wallpaper
#
# ==== Arguments
#
# The script does not accept any parameters.


export LOG_DONE="[\e[32mDONE\e[0m]"
export LOG_ERROR="[\e[1;31mERROR\e[0m]"
export LOG_INFO="[\e[34mINFO\e[0m]"
export LOG_WARN="[\e[93mWARN\e[0m]"
BASHRC_FILE="$HOME/.bashrc"


echo -e "$LOG_INFO Change bash prompt"
promptDefinition="\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$(__git_ps1) \$ "
grep -qxF "export PS1='${promptDefinition}'" "$BASHRC_FILE" || echo "export PS1='${promptDefinition}'" >>"$BASHRC_FILE"
echo -e "$LOG_DONE Changed prompt"


echo -e "$LOG_INFO Write entries to $BASHRC_FILE (if not already present)"
entries=(
  'alias ll="ls -alFh --color=auto"'
  'alias ls="ls -a --color=auto"'
  'alias grep="grep --color=auto"'
  'alias pull-all-repos="git all pull"'
  "alias reset-conky=\"(killall conky && cd $HOME/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/utils/conky && ./run.sh)\""
  "alias reset-sound=\"pulseaudio --start\""
  'alias ff="~/work/repos/sebastian-sommerfeld-io/infrastructure/src/main/workstations/kobol/utils/scripts/bash-aliases/firefox.sh"'
  'export LOG_DONE="[\e[32mDONE\e[0m]"'
  'export LOG_ERROR="[\e[1;31mERROR\e[0m]"'
  'export LOG_INFO="[\e[34mINFO\e[0m]"'
  'export LOG_WARN="[\e[93mWARN\e[0m]"'
  'export Y="\e[93m"' # text yellow
  'export P="\e[35m"' # text purple
  'export D="\e[0m"' # text default (white)
)
for entry in "${entries[@]}"
do
  echo -e "$LOG_INFO Add entry -> $entry"
  grep -qxF "$entry" "$BASHRC_FILE" || echo "$entry" >> "$BASHRC_FILE"
done
echo -e "$LOG_DONE All entries to $BASHRC_FILE written"


echo -e "$LOG_INFO Setup filesystem structure for $HOME"
folders=(
  "$HOME/.config/autostart/"
  "$HOME/logs"
  "$HOME/work"
  "$HOME/work/repos"
  "$HOME/work/repos/sommerfeld-io"
  "$HOME/work/repos/sommerfeld.sebastian"
  "$HOME/work/repos/sebastian-sommerfeld-io"
  "$HOME/work/provinzial"
  "$HOME/work/tools"
  "$HOME/virtualmachines"
  "$HOME/tmp"
  "$HOME/.ssh"
)
for folder in "${folders[@]}"
do
  echo -e "$LOG_INFO Create -> $folder"
  mkdir "$folder"
done
echo -e "$LOG_DONE Filesystem structure for $HOME created"


usbDir="/media/$USER/USB-1TB/.kobol-backups/.ssh"
sshDir="$HOME/.ssh"
echo -e "$LOG_INFO Restore all SSH keys and known_hosts from $usbDir to $sshDir"
if [ -d "$usbDir" ]; then
  (
    cd "$sshDir" || exit
    echo -e "$LOG_INFO Copy keys from $usbDir to $sshDir"
    cp -a "$usbDir/." "$sshDir" # https://askubuntu.com/questions/86822/how-can-i-copy-the-contents-of-a-folder-to-another-folder-in-a-different-directo

    echo -e "$LOG_INFO Set owner and permissions for keys"

    sudo chmod -R 600 "./*"
    sudo chmod -R 644 "*.key.pub"
    sudo chown -R "$USER:$USER" "./*"
    
    echo -e "$LOG_DONE Restored all SSH keys from $usbDir to $sshDir"
  )
else
  echo -e "$LOG_ERROR Directory on USB drive '$usbDir' not accessible"
  echo -e "$LOG_ERROR No SSH keys restored"
fi


echo -e "$LOG_INFO Change SSH key verification policy for IP range used by Vagrant"
configFile="$HOME/.ssh/config"
sudo rm "$configFile"

sudo tee -a "$configFile" > /dev/null <<EOT
Host 192.168.56.*
  StrictHostKeyChecking accept-new
  UserKnownHostsFile /dev/null
EOT

sudo chmod 644 "$configFile"
sudo chown "$USER:$USER" "$configFile"
echo -e "$LOG_DONE Configured SSH key verification policy"


wpFolder="$HOME/Pictures/wallpapers"
wpFile="1.jpg"
echo -e "$LOG_INFO Create wallpapers folder '$wpFolder'"
rm -rf "$wpFolder"
mkdir "$wpFolder"
echo -e "$LOG_INFO Copy image files to '$wpFolder'"
cp -a "assets/wallpapers/." "$wpFolder"
echo -e "$LOG_INFO Update wallpaper"
gsettings set org.gnome.desktop.background picture-uri "file:///$HOME/Pictures/wallpapers/$wpFile"


echo -e "$LOG_INFO Show Battery Percentage"
gsettings set org.gnome.desktop.interface show-battery-percentage true
