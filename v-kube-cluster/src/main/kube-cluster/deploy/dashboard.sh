#!/bin/bash

# load common vars (../ just once due to cd in script calling this deploy script)
# shellcheck disable=SC1091
source ../vars.sh

################################################################################
#    dashboard                                                                 #
################################################################################

# https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard

echo -e "$LOG_INFO Start deployment of application: dashboard"
echo -e "$LOG_INFO Start deployment"
vagrant ssh "${k8s_master_node:?}" -c 'kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml'

# Creating a Service Account
vagrant ssh "${k8s_master_node:?}" -c 'sudo tee -a "/home/vagrant/.kube/deployment-configs/dashboard-adminuser.yaml" > /dev/null <<EOT
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
EOT'
vagrant ssh "${k8s_master_node:?}" -c 'kubectl apply -f "/home/vagrant/.kube/deployment-configs/dashboard-adminuser.yaml"'
echo -e "$LOG_DONE Created service account"

# Creating a ClusterRoleBinding
vagrant ssh "${k8s_master_node:?}" -c 'sudo tee -a "/home/vagrant/.kube/deployment-configs/dashboard-cluster-role-binding.yaml" > /dev/null <<EOT
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOT'
vagrant ssh "${k8s_master_node:?}" -c 'kubectl apply -f "/home/vagrant/.kube/deployment-configs/dashboard-cluster-role-binding.yaml"'
echo -e "$LOG_DONE Created cluster role binding"

# Get secret
#token=$(vagrant ssh "${k8s_master_node:?}" -c 'kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}"')
token=$(vagrant ssh "${k8s_master_node:?}" -c "kubectl -n kubernetes-dashboard get secret \$(kubectl -n kubernetes-dashboard get sa/admin-user -o jsonpath=\"{.secrets[0].name}\") -o go-template=\"{{.data.token | base64decode}}\"")

echo -e "$LOG_INFO ***   BEARER TOKEN   *********************************************"
echo
echo -e "\e[33m$token\e[0m"
echo
echo -e "$LOG_INFO ******************************************************************"
echo "$token" > ../../../target/kubernetes-dashboard-token.txt
echo -e "$LOG_DONE Token written to target/kubernetes-dashboard-token.txt"

echo -e "$LOG_INFO Visit from host machine: http://localhost:8001/ui"
echo -e "$LOG_INFO Visit from host machine: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"
echo -e "$LOG_DONE ------------------------------------------------------------------"
echo -e "$LOG_DONE Deployed application: dashboard"
echo -e "$LOG_DONE ------------------------------------------------------------------"
