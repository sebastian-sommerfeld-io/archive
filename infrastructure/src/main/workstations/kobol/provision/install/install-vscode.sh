#!/bin/bash
# @file install-vscode.sh
# @brief Install Visual Studio Code.
#
# @description The script installs Visual Studio Code.
#
# ==== Arguments
#
# The script does not accept any parameters.


echo -e "$LOG_INFO Install VSCode"
sudo snap install --classic code

echo -e "$LOG_INFO Install extensions"
extensions=(
  'redhat.ansible'
  'asciidoctor.asciidoctor-vscode'
  'aaron-bond.better-comments'
  'chef-software.chef'
  'ms-azuretools.vscode-docker'
  'hashicorp.terraform'
  'ms-toolsai.jupyter'
  'ms-toolsai.jupyter-keymap'
  'ms-toolsai.jupyter-renderers'
  'ms-python.vscode-pylance'
  'ms-python.python'
  'rebornix.ruby'
  'timonwong.shellcheck'
  'wingrunr21.vscode-ruby'
  'redhat.vscode-yaml'
  'jebbs.plantuml'
  'ms-vscode-remote.remote-containers'
  'vscjava.vscode-java-pack'
  'pomdtr.markdown-kroki'
  'recode4dev.jenkinsfile'
  'cschleiden.vscode-github-actions'
)
for extension in "${extensions[@]}"
do
  echo -e "$LOG_INFO Install extension -> $extension"
  code --install-extension "$extension"
done

echo -e "$LOG_DONE Installed VSCode"
