#!/bin/bash

### UTILITIES ###
. .lpc-katacoda-common/logging.sh

function get_helm3 {
  warn "Updating to helm3"
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
}

function get_ansible {
  pip3 install ansible openshift jmespath boto3
  ansible-galaxy collection install community.kubernetes
}

function deploy_nginx {
  warn "Deploying Nginx Ingress Controller"
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm install nginx-ingress ingress-nginx/ingress-nginx \
    --version 2.16.0 \
    --set controller.kind=Deployment \
    --set controller.service.type=NodePort\
    --set controller.service.nodePorts.http=30080
}
