#!/bin/bash
# @file test-setup.sh
# @brief Test the setup for machine "caprica" inside Vagrantbox "caprica-test".
#
# @description This script tests the setup for the machine "caprica". To test the setup and provisioning steps, this
# script creates and starts the Vagrantbox "caprica-test" and runs all scripts and playbooks inside this Vagrantbox.
#
# IMPORTANT: This script must run on a physical machine directly. Running inside a Vagrantbox does not work because 
# Vagrantboxes don't come with VirtualBox and Vagrant inside (which are needed because the ansible playbook is tested
# inside a Vagrantbox).
#
# ==== Arguments
#
# The script does not accept any parameters.


BOX_IP=""
BOX_USER="seb"

COMPOSE_PATH="src/main/workstations/caprica/services"
COMPOSE_FILENAME="docker compose.yml"


case $HOSTNAME in
  ("caprica") echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  ("kobol")   echo -e "$LOG_INFO Run tests on machine '$HOSTNAME'";;
  (*)         echo -e "$LOG_ERROR Script not running on expected machine!!!" && exit;;
esac


# @description Step 1: Validate the Vagrantfile and InSpec profile and prepare startup.
function prepare() {
  echo -e "$LOG_INFO Validate Vagrantfile"
  vagrant validate

  (
    cd ../../../../ || exit # project root

    echo -e "$LOG_INFO Validate yaml"
    docker run -it --rm --volume "$(pwd):/data" --workdir "/data" cytopia/yamllint:latest src/main/workstations/caprica/provision/ansible-playbook.yml
  )
}


# @description Step 2: Startup and provision the Vagrantbox (provisioning is a Vagrant feature). Show the SSH config of
# the Vagrantbox as well.
function startup() {
  echo && docker run --rm mwendler/figlet:latest "Startup" && echo

  echo -e "$LOG_INFO Create and startup Vagrantbox"
  vagrant up

  echo -e "$LOG_INFO SSH config for this Vagrantbox"
  vagrant ssh-config
  
  echo -e "$LOG_INFO Which remote user"
  vagrant ssh -c 'whoami'

  echo -e "$LOG_INFO Read IP address from vagrantbox"
  tmp=$(vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null)
  BOX_IP=$(echo "$tmp" | sed 's/\r$//') # remove \r from end of string
  echo -e "$LOG_INFO IP = $BOX_IP"
}


# @description Step 3: Run tests to check the correct setup of the Vagrantbox.
function test() {
  echo && docker run --rm mwendler/figlet:latest "Test" && echo

  echo -e "$LOG_INFO List ssh keys for user $BOX_USER"
  vagrant ssh -c "ls -alF /home/$BOX_USER/.ssh"

  echo -e "$LOG_INFO Show known_hosts for user $BOX_USER"
  vagrant ssh -c "cat /home/$BOX_USER/.ssh/known_hosts"

  echo -e "$LOG_INFO Test Docker installation"
  vagrant ssh -c "docker run --rm hello-world:latest"

  echo -e "$LOG_INFO Test deployments: deploy docker compose services to remote host"
  (
    cd ../../../../ || exit # project root

    for d in "$COMPOSE_PATH"/*
    do
      echo -e "$LOG_INFO Deploy $d/$COMPOSE_FILENAME"
      DOCKER_HOST="ssh://$BOX_USER@$BOX_IP" docker compose -f "$d/$COMPOSE_FILENAME" up -d
    done
  )

  echo -e "$LOG_INFO Delegate to inspec script"
  bash ./test-inspec.sh "caprica-test" "$BOX_IP" "$BOX_USER"

  echo -e "$LOG_INFO Test git: clone repository from github (https)"
  vagrant ssh -c "(cd repos && git clone https://github.com/sebastian-sommerfeld-io/playgrounds.git)"

  echo -e "$LOG_INFO Test git: clone repository from gitlab (https)"
  vagrant ssh -c "(cd repos && git clone https://gitlab.com/sommerfeld.sebastian/website-masterblender-de.git)"

  SLEEP_SECONDS="60"
  echo -e "$LOG_INFO Sleep for $SLEEP_SECONDS seconds"
  sleep "$SLEEP_SECONDS"
  echo -e "$LOG_INFO Continue"

  echo -e "$LOG_INFO List all running docker services"
  vagrant ssh -c "docker ps"

  echo -e "$LOG_INFO Check node_exporter"
  vagrant ssh -c "curl -I localhost:9100"
  vagrant ssh -c "curl -I localhost:9100/metrics"
  curl -I "$BOX_IP:9100"
  curl -I "$BOX_IP:9100/metrics"

  echo -e "$LOG_INFO Check cAdvisor"
  vagrant ssh -c "curl -I localhost:9110"
  curl -I "$BOX_IP:9110"

  echo -e "$LOG_INFO Check Portainer"
  vagrant ssh -c "curl -I localhost:9990"
  curl -I "$BOX_IP:9990"

  echo -e "$LOG_INFO Check Jenkins"
  vagrant ssh -c "curl -I localhost:9080"
  curl -I "$BOX_IP:9080"
}


# @description Step 4: Shutdown and destroy the Vagrantbox and cleanup the local filesystem.
function shutdown() {
  echo && docker run --rm mwendler/figlet:latest "Shutdown" && echo

  echo -e "$LOG_INFO Shutdown Vagrantbox"
  vagrant halt

  echo -e "$LOG_INFO Remove Vagrantbox and cleanup filesystem"
  vagrant destroy -f
  rm -rf .vagrant
  rm -rf ./*.log
}


# @description Step 5: Auto-generate Asciidoc pages
# todo: Move this function into separate dedicated pipeline. Only job of the pipeline is beeing an adoc generator.
function generateDocs() {
  echo && docker run --rm mwendler/figlet:latest "Genereate Docs" && echo

  # from ansible-playbook.yml
  (
    cd ../../../../ || exit # project root

    playbook="src/main/workstations/caprica/provision/ansible-playbook.yml"

    echo -e "$LOG_INFO Read username and password from playbook and write to adoc"
    adoc="docs/modules/ROOT/partials/generated/ansible/caprica-vars.adoc"

    default_username=$(docker run --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      mikefarah/yq:latest eval '.[] | select(.name).vars.[] | select(.default_username).[]' $playbook)

    default_password=$(docker run --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      mikefarah/yq:latest eval '.[] | select(.name).vars.[] | select(.default_password).[]' $playbook)

    rm "$adoc"
    (
      echo ":user: $default_username"
      echo ":pass: $default_password"
    ) > "$adoc"

    echo -e "$LOG_INFO Read tasks from playbook and write to adoc"
    adoc="docs/modules/ROOT/partials/generated/ansible/caprica-ansible-playbook-tasks.adoc"
    tasks=$(docker run --rm \
      --volume "$(pwd):$(pwd)" \
      --workdir "$(pwd)" \
      mikefarah/yq:latest eval '.[] | select(.name).tasks.[] | .name' $playbook)

    tasks=$(echo "$tasks" | sed 's/^/. /')

    rm "$adoc"
    echo "$tasks" > "$adoc"
  )

  # from docker compose.yml
  (
    cd ../../../../ || exit # project root

    for d in "$COMPOSE_PATH"/*
    do
      compose="$d/$COMPOSE_FILENAME"
      stack=${d//*\/}
      adoc="docs/modules/ROOT/partials/generated/ansible/caprica-docker compose-stack-$stack.adoc"

      echo -e "$LOG_INFO Read services for stack $stack and generate asciidoc"
      echo -e "$LOG_INFO Compose file = $compose"
      
      services=$(docker run --rm \
        --volume "$(pwd):$(pwd)" \
        --workdir "$(pwd)" \
        mikefarah/yq:latest eval '.services.[] | "|" + .container_name + " |" + .image + " |" + .labels.url + " |" + .labels.description + " |" + .restart' "$compose")
      
      rm "$adoc"
      (
        echo '[cols="2,4,1,3,1", options="header"]'
        echo '|==='
        echo '|Container Name |Image |URL |Description |Restart'
        echo "$services"
        echo '|==='
        echo
      ) > "$adoc"
    done
  )
}


echo -e "$LOG_INFO Run tests from $P$(pwd)$D"
prepare
startup
test
shutdown
generateDocs
