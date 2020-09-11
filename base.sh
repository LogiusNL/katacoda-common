#!/bin/bash

### UTILITIES ###

# Set Colors
bold=$(tput smso)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 2)
white=$(tput setaf 0)
tan=$(tput setaf 3)
blue=$(tput setaf 4)

# Headers and Logging
underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
h1() { printf "\n${underline}${bold}${blue}%s${reset}\n" "$@"
}
h2() { printf "\n${underline}${bold}${white}%s${reset}\n" "$@"
}
debug() { printf "${white}%s${reset}\n" "$@"
}
info() { printf "${white}➜ %s${reset}\n" "$@"
}
success() { printf "${green}✔ %s${reset}\n" "$@"
}
error() { printf "${red}✖ %s${reset}\n" "$@"
}
warn() { printf "${tan}➜ %s${reset}\n" "$@"
}
bold() { printf "${bold}%s${reset}\n" "$@"
}
note() { printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

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
    --set controller.kind=Deployment \
    --set controller.service.type=NodePort\
    --set controller.service.nodePorts.http=30080
}
