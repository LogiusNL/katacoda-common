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

function deploy_longhorn {
  warn "Installing open-iscsi on nodes"
  apt install -y open-iscsi
  ssh node01 apt install -y open-iscsi
  warn "Deploying Longhorn Storage Provider"
  kubectl create namespace longhorn-system
  helm repo add longhorn https://charts.longhorn.io
  helm install longhorn longhorn/longhorn \
    --namespace longhorn-system \
    --set persistence.defaultClass=true \
    --set persistence.defaultClassReplicaCount=1 \
    --set persistence.reclaimPolicy=Delete \
    --set defaultSettings.guaranteedEngineCPU=0.1 \
    --set defaultSettings.taintToleration="stc.subku.be/storage=true:PreferNoSchedule;" \
    --set enablePSP=true \
    --set resources.limits.cpu=50m \
    --set resources.limits.memory=128Mi \
    --set resources.requests.cpu=50m \
    --set resources.requests.memory=128Mi
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
