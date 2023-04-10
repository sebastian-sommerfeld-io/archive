#!/bin/bash
# @file run-inspec.sh
# @brief Run Inspec tests.
#
# @description This script runs the tets from the inspec profiles.
#
# todo: Move inspec tests into separate dedicated pipeline. Only job of the pipeline is auditing.
#
# ==== Arguments
#
# * *$1* (string): Profile name to test on top of profile "baseline" (mandatory)
# * *$1* (string): Host to test (mandatory)
# * *$1* (string): Username to connect to host (mandatory)


PROFILE="$1"
HOST="$2"
USER="$3"


if [ -z "$PROFILE" ]
then
  echo -e "$LOG_ERROR Param missing: profile (String)"
  echo -e "$LOG_ERROR exit" && exit 0
fi
if [ -z "$HOST" ]
then
  echo -e "$LOG_ERROR Param missing: host (String)"
  echo -e "$LOG_ERROR exit" && exit 0
fi
if [ -z "$USER" ]
then
  echo -e "$LOG_ERROR Param missing: user (String)"
  echo -e "$LOG_ERROR exit" && exit 0
fi


case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!!" && exit;;
esac


# @description Utility function to wrap inspec in Docker container. Calling this function avoids multiple ``docker run``
# commands. The container uses the SSH setup and the git installation from the host.
function inspec() {
  if [ "$1" == "check" ]; then
    docker run -it --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      chef/inspec:latest "$@" --chef-license=accept
  else
    docker run -it --rm \
      --volume "$HOME/.ssh:/root/.ssh:ro" \
      --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      --network host \
      chef/inspec:latest "$@" --target=ssh://"$USER@$HOST" --key-files=/root/.ssh/id_rsa --chef-license=accept
  fi
}


echo -e "$LOG_INFO Working dir = $(pwd)"
echo -e "$LOG_INFO Connetion = $USER@$HOST"

echo -e "$LOG_INFO Validate inspec profiles"
inspec check "inspec-profiles/$PROFILE"
inspec check "inspec-profiles/baseline"

echo -e "$LOG_INFO Run inspec profiles"
inspec exec "inspec-profiles/$PROFILE"
inspec exec "inspec-profiles/baseline"
