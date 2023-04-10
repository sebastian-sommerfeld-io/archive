#!/bin/bash
# @file docker-compose-services.sh
# @brief Start and stop docker-compose services.
#
# @description This script starts and stops docker-compose services on the respective machine.
# The script detects the the services depending on $HOSTNAME and then provides a select
# menu to choose a stack for deployment.
#
# ==== Arguments
#
# The script does not accept any parameters.


OPTION_START="start"
OPTION_STOP="stop"
OPTION_RESTART="restart"
OPTION_LOGS="logs"

KOBOL="kobol"
SERVICES_PATH="$HOSTNAME/services"
STACK=""


# @description Utility function to startup docker-compose services.
function startup() {
  echo -e "$LOG_INFO Startup stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose up -d
}


# @description Utility function to shutdown docker-compose services.
function shutdown() {
  echo -e "$LOG_INFO Shutdown stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose down -v --rmi all
}


# @description Utility function to show docker-compose logs.
function logs() {
  echo -e "$LOG_INFO Show logs for stack $P$STACK$D on $P$HOSTNAME$D"
  docker-compose logs -f
}


if [ "$KOBOL" = "$HOSTNAME" ]; then
  SERVICES_PATH="$HOSTNAME/docker/services"
fi


echo -e "$LOG_INFO ========== System Info =================================================="
echo "        Hostname: $HOSTNAME"
hostnamectl
echo "          Kernel: $(uname -v)"
echo "   Services path: $SERVICES_PATH"
echo -e "$LOG_INFO ========================================================================="


echo -e "$LOG_INFO Deploy docker services for machine $P$HOSTNAME$D"
(
  cd "$SERVICES_PATH" || exit

  echo -e "$LOG_INFO Select the docker-compose stack"
  select s in */; do
    STACK="${s::-1}"
    break
  done


  (
    cd "$STACK" || exit

    echo -e "$LOG_INFO Select the action"
    select s in "$OPTION_START" "$OPTION_STOP" "$OPTION_RESTART" "$OPTION_LOGS"; do

      case "$s" in
        "$OPTION_START" )
          startup
          break;;
        "$OPTION_STOP" )
          shutdown
          break;;
        "$OPTION_RESTART" )
          shutdown
          startup
          break;;
        "$OPTION_LOGS" )
          logs
          break;;
      esac

    done
  )
)
