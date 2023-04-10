#!/bin/bash
# @file tests.sh
# @brief Start and stop the docker stack containing the Jira runtime.
#
# @description The script starts and stops the docker compose stack used for the local jira
# instance. The ``local/tron:test`` image is build before starting Jira.
#
# === Script Arguments
#
# * *$1* (string): Command (``start``, ``logs``, ``stop``)
#
# === Script Example
#
# [source, bash]
# ```
# ./tests.sh
# ```


readonly START="start"
readonly LOGS="logs"
readonly STOP="stop"
readonly UPDATE_DB="update_db"

readonly BASE_URL="http://localhost:8080"
readonly USER="admin"
readonly PASS="admin"

readonly CONTAINER_NAME="jira"

ARG="$1"
readonly ARG

# Include local bash modules
source "../bash-modules/log.sh"


if [ -z "$ARG" ]; then
  LOG_ERROR "Param missing: command ($START | $LOGS | $STOP | $UPDATE_DB)"
  LOG_ERROR "exit" && exit 0
fi


set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace


# @description When starting Jira, the instance is provided with a h2db and is populated with a
# license, users and projects so there is no need re-run the setup wizard all the time. This data
# defines a baseline which is the same everytime this test-stack starts.
#
# The only issue is, that there is no data visible in the UI after starting up because  there is
# no (or at least no uncorrupted) index. A new index must be created in the foreground triggered
# through the link:https://docs.atlassian.com/software/jira/docs/api/REST/8.22.6[Jira REST API].
#
# @example
#    index
function index() {
  while true; do
    s="10s"
    LOG_INFO "Waiting for Jira startup ... sleeping for $s"
    sleep "$s"
    
    httpCode=$(curl --location --request GET "$BASE_URL/rest/api/2/serverInfo?doHealthCheck=true" \
      -s -o /dev/null -w "%{http_code}" \
      --user "$USER:$PASS" \
      --header 'Content-Type: application/json')
    
    LOG_INFO "Jira answered with $httpCode"
    if [[ "$httpCode" == "200" ]]; then
      LOG_INFO "Jira is up-and-running"
      break
    fi
  done

  LOG_INFO "Trigger re-index"
  response=$(curl -s --location --request POST "$BASE_URL/rest/api/2/reindex?type=FOREGROUND" \
    --user "$USER:$PASS" \
    --header 'Accept: application/json')
  LOG_INFO "$response"
  
  sleep "10s"

  LOG_INFO "Check re-index"
  response=$(curl -s --location --request GET "$BASE_URL/rest/api/2/reindex" \
    --user "$USER:$PASS" \
    --header 'Content-Type: application/json')
  LOG_INFO "$response"
}


case "$ARG" in
  "$START" )
    LOG_HEADER "Start stack"
    docker-compose up --build -d
    index
  ;;
  "$LOGS" )
    LOG_HEADER "Show logs"
    docker-compose logs
  ;;
  "$STOP" )
    LOG_HEADER "Stop stack"
    docker-compose down -v --rmi all --remove-orphans
  ;;
  "$UPDATE_DB" )
    LOG_HEADER "Update H2DB from a running Jira instance"
    docker cp "$CONTAINER_NAME:/var/atlassian/application-data/jira/database/h2db.mv.db" "runtime/assets/jira/database/h2db.mv.db"
  ;;
esac
