#!/bin/bash

home="/home/vagrant"

# prompt color
bashrc="$home/.bashrc"
promptDefinition="\${debian_chroot:+(\$debian_chroot)}\[\033[0;35m\]\u@\h\[\033[00m\]:\[\033[00;35m\]\w\[\033[00m\]\$ "
grep -qxF "export PS1='${promptDefinition}'" "$bashrc" || echo "export PS1='${promptDefinition}'" >>"$bashrc"
echo "[DONE] Changed prompt"

# aliases in .bashrc
aliases=(
  'alias ll="ls -alFh --color=auto"'
  'alias ls="ls -a --color=auto"'
  'alias grep="grep --color=auto"'
  "cheatsheet() { clear && curl \"cheat.sh/\$1\" ; }"
  'export LOG_DONE="[\e[32mDONE\e[0m]"'
  'export LOG_ERROR="[\e[1;31mERROR\e[0m]"'
  'export LOG_INFO="[\e[34mINFO\e[0m]"'
  'export LOG_WARN="[\e[93mWARN\e[0m]"'
)

for alias in "${aliases[@]}"; do
  grep -qxF "$alias" "$bashrc" || echo "$alias" >> "$bashrc"
done
echo "[DONE] Add aliases to .bashrc"

echo "[DONE] ------------------------------------------------------------------"
echo "[DONE] Bash setup for $home complete"
echo "[DONE] ------------------------------------------------------------------"