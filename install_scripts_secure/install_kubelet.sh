#!/bin/bash

DIR=$( cd "$(dirname "$0")" && pwd )

source ${DIR}/../config

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
After=docker.service
Requires=docker.service

[Service]
ExecStart=/opt/kubernetes/server/bin/kubelet \
--hostname-override=$(hostname -s) \
--api-servers=https://${MASTER_LB_IP}:6443 \
--logtostderr=true \
--tls-cert-file=/srv/kubernetes/node.crt \
--tls-private-key-file=/srv/kubernetes/node.key \
--kubeconfig=/srv/kubernetes/kubeconfig

Restart=on-failure
KillMode=process

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kubelet
systemctl restart kubelet
