#!/bin/bash

SCRIPT_PATH="install_scripts"
DIR=$( cd "$(dirname "$0")" && pwd )
source ${DIR}/config

# use for ca 
#cp -r certification/$CA_DIR /srv/

#curl -L 'https://github.com/kubernetes/kubernetes/releases/download/v1.4.9/kubernetes.tar.gz' -O kubernetes.tar.gz
#tar xvf  ${DIR}/kubernetes.tar.gz
tar zxvf source/kubernetes-server-linux-amd64.tar.gz -C /opt/

/bin/bash $SCRIPT_PATH/install_kubelet.sh
/bin/bash $SCRIPT_PATH/install_kube_proxy.sh
/bin/bash $SCRIPT_PATH/install_flannel.sh

#systemctl daemon-reload
#systemctl enable kubelet
#systemctl enable kube-proxy
#systemctl enable flanneld
#systemctl restart kubelet
#systemctl restart kube-proxy
#systemctl restart flanneld
