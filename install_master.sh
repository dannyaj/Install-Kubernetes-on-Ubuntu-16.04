#!/bin/bash

source config
SCRIPT_PATH="install_scripts"

cp -r certification/$CA_DIR /srv/
#curl -L 'https://github.com/kubernetes/kubernetes/releases/download/v1.4.9/kubernetes.tar.gz' -O kubernetes.tar.gz
#tar xvf  source/kubernetes*.tar.gz
tar zxvf source/kubernetes-server-linux-amd64.tar.gz -C /opt/

/bin/bash $SCRIPT_PATH/install_etcd.sh
/bin/bash $SCRIPT_PATH/install_kube_apiserver.sh
/bin/bash $SCRIPT_PATH/install_kube_controller_manager.sh
/bin/bash $SCRIPT_PATH/install_kube_scheduler.sh
#/bin/bash $SCRIPT_PATH/install_flannel.sh

cp /opt/kubernetes/server/bin/kubectl /usr/bin
#systemctl daemon-reload
#systemctl enable kube-apiserver
#systemctl enable kube-controller-manager
#systemctl enable kube-scheduler
#systemctl enable flanneld
#systemctl start kube-apiserver
#systemctl start kube-controller-manager
#systemctl start kube-scheduler
#systemctl start flanneld
