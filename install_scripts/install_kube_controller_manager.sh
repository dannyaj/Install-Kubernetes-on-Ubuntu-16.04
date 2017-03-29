#!/bin/bash

HOME=$( cd "$(dirname "$0")" && pwd )
source $HOME/../config

cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
[Unit]
Description=Kubernetes Controller Manager
Documentation=https://github.com/kubernetes/kubernetes

[Service]
User=root
ExecStart=/opt/kubernetes/server/bin/kube-controller-manager \
--master=127.0.0.1:8080 \
--root-ca-file=/srv/kubernetes/ca.crt \
--service-account-private-key-file=/srv/kubernetes/server.key \
--logtostderr=true
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-controller-manager
systemctl start kube-controller-manager
