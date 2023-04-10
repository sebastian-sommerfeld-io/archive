#!/bin/bash
# @file ansible.sh
# @brief Run Ansible playbooks against workstations.
#
# @description This script runs Ansible playbooks against workstations. Ansible runs in Docker.
#
# todo: don't automatically run against all servers
#
# todo: put inspec tests into dedicated pipeline
#
# ==== Arguments
#
# The script does not accept any parameters.


MACHINE=""
ANSIBLE_PLAYBOOK="provision/ansible-playbook.yml"
ANSIBLE_INVENTORY="ansible-hosts.ini"


# @description Wrapper function to encapsulate link:https://hub.docker.com/r/cytopia/ansible[ansible in a docker container].
# The current working directory is mounted into the container and selected as working directory so that all file are
# available to ansible. Paths are preserved.
#
# @example
#    echo "test: $(invoke ansible --version)"
#
# @arg $@ String The ansible commands (1-n arguments) - $1 is mandatory
#
# @exitcode 8 If param with ansible command is missing
function invoke() {
  if [ -z "$1" ]; then
    echo -e "$LOG_ERROR No command passed to the ansible container"
    echo -e "$LOG_ERROR exit" && exit 8
  fi

  docker run -it --rm \
    --volume "$HOME/.ssh:/root/.ssh:ro" \
    --volume "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" \
    --volume /etc/timezone:/etc/timezone:ro \
    --volume /etc/localtime:/etc/localtime:ro \
    --volume "/home/sebastian/.ssh:/home/sebastian/.ssh:ro" \
    --volume "$(pwd):$(pwd)" \
    --workdir "$(pwd)" \
    cytopia/ansible:latest "$@"
}


# @description Facade to map ``ansible`` command.
#
# @example
#    echo "test: $(ansible --version)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible() {
  invoke ansible "$@"
}


# @description Facade to map ``ansible-playbook`` command.
#
# @example
#    echo "test: $(ansible-playbook playbook.yml)"
#
# @arg $@ String The ansible-playbook commands (1-n arguments) - $1 is mandatory
function ansible-playbook() {
  invoke ansible-playbook "$@"
}


echo -e "$LOG_INFO Select the Ansible playbook"
select d in */; do
  MACHINE="${d::-1}"
  break
done

echo -e "$LOG_INFO Override user/password from inventory?"
echo -e "$LOG_WARN Choosing$P yes$D results in a connection with the user$P sebastian$D and ansible prompting for a password."
echo -e "$LOG_WARN Most of the time, the better choice is to NOT override the credentials!"
select o in "yes" "no"; do
   case "$o" in
    "yes" )
      echo -e "$LOG_INFO Install $MACHINE using playbook $MACHINE/$ANSIBLE_PLAYBOOK"
      ansible-playbook "$MACHINE/$ANSIBLE_PLAYBOOK" --extra-vars "ansible_user=sebastian" --ask-pass --ask-become-pass --inventory "$ANSIBLE_INVENTORY" -vv

      break;;
    "no" )
      echo -e "$LOG_INFO Install $MACHINE using playbook $MACHINE/$ANSIBLE_PLAYBOOK"
      ansible-playbook "$MACHINE/$ANSIBLE_PLAYBOOK" --inventory "$ANSIBLE_INVENTORY" -vv

      break;;
  esac
done


echo -e "$LOG_INFO Delegate to inspec script"
(
  cd ../../test/workstations/caprica || exit
  bash ./test-inspec.sh "caprica" "caprica.fritz.box" "seb"
)
