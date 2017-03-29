#!/bin/bash

HOME=$( cd "$(dirname "$0")" && pwd )
source $HOME/../config

cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
User=root
ExecStart=/opt/kubernetes/server/bin/kube-scheduler \
--logtostderr=true \
--master=127.0.0.1:8080
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-scheduler
systemctl start kube-scheduler
