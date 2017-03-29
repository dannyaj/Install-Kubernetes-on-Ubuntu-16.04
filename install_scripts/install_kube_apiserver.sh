#!/bin/bash

HOME=$( cd "$(dirname "$0")" && pwd )
source $HOME/../config

cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes
After=network.target

[Service]
User=root
ExecStart=/opt/kubernetes/server/bin/kube-apiserver \
--insecure-bind-address=0.0.0.0 \
--insecure-port=8080 \
--etcd-servers=http://${ETCD_1_IP}:2379,http://${ETCD_2_IP}:2379 \
--logtostderr=true \
--allow-privileged=false \
--service-cluster-ip-range=${SERVICE_CLUSTER_IP_RANGE} \
--admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,SecurityContextDeny,ResourceQuota \
--service-node-port-range=30000-32767 \
--advertise-address=${ADVERTISE_IP} \
--client-ca-file=/srv/kubernetes/ca.crt \
--tls-cert-file=/srv/kubernetes/server.crt \
--tls-private-key-file=/srv/kubernetes/server.key
Restart=on-failure
Type=notify
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-apiserver
systemctl start kube-apiserver
