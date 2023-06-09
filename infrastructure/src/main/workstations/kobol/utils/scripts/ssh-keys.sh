#!/bin/bash
# @file ssh-keys.sh
# @brief Create public/private ssh keypair.
#
# @description This script create public/private ssh keypair with the given name. The generated keys are written
# to ``$HOME/.ssh`` with ``$KEY_NAME.key`` and ``$KEY_NAME.key.pub``.
#
# ==== Arguments
#
# * *$1* (String): KEY_NAME (mandatory)

KEY_NAME="$1"
KEY_FILE=""

YES="yes"
NO="no"


echo -e "$LOG_INFO Create ssh key-pair"


if [ -z "$KEY_NAME" ]
then
  echo -e "$LOG_ERROR Param missing: key name (string without blanks)"
  echo -e "$LOG_ERROR No private and public key created"
  echo -e "$LOG_ERROR exit"
  exit 0
fi


echo -e "$LOG_INFO Add '.key' to filename?"
echo -e "$LOG_INFO     yes = '$P$KEY_NAME.key$D' and '$P$KEY_NAME.key.pub$D'"
echo -e "$LOG_INFO     no  = '$P$KEY_NAME$D' and '$P$KEY_NAME.pub$D'"
select s in "$YES" "$NO"; do
  case "$s" in
    "$YES" ) KEY_FILE="$HOME/.ssh/$KEY_NAME.key"; break;;
    "$NO" )  KEY_FILE="$HOME/.ssh/$KEY_NAME"; break;;
  esac
done


(
  echo -e "$LOG_INFO Create new ssh key-pair: $KEY_NAME"
  cd "$HOME/.ssh" || exit
  ssh-keygen -f "$KEY_FILE" -t ed25519 -C "sebastian@sommerfeld.io"

  echo -e "$LOG_INFO Start the ssh-agent in background"
  eval "$(ssh-agent -s)"

  echo -e "$LOG_INFO Add ssh key to the ssh-agent"
  ssh-add "$KEY_FILE"

  echo -e "$LOG_DONE Created ssh key-pair"
)
