#!/bin/bash

#curl -L https://github.com/coreos/etcd/releases/download/v3.0.7/etcd-v3.0.7-linux-amd64.tar.gz -o etcd-v3.0.7-linux-amd64.tar.gz
#tar xzvf etcd-v3.0.7-linux-amd64.tar.gz && cd etcd-v3.0.7-linux-amd64

HOME=$( cd "$(dirname "$0")" && pwd )
source $HOME/../config

tar xzvf source/etcd*.tar.gz && cd etcd*linux-amd64
mkdir -p /opt/etcd/bin
cp etcd* /opt/etcd/bin/
mkdir -p /var/lib/etcd/
mkdir -p /opt/etcd/config/

cat <<EOF | sudo tee /opt/etcd/config/etcd.conf
ETCD_DATA_DIR=/var/lib/etcd
ETCD_NAME=$(hostname -s)
ETCD_LISTEN_PEER_URLS=http://0.0.0.0:2380
ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
ETCD_INITIAL_CLUSTER_STATE=new
ETCD_INITIAL_CLUSTER=${ETCD_1_NAME}=http://${ETCD_1_IP}:2380,${ETCD_2_NAME}=http://${ETCD_2_IP}:2380
ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${ADVERTISE_IP}:2380
ETCD_ADVERTISE_CLIENT_URLS=http://${ADVERTISE_IP}:2379
ETCD_HEARTBEAT_INTERVAL=6000
ETCD_ELECTION_TIMEOUT=30000
GOMAXPROCS=$(nproc)
EOF

cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=Etcd Server
Documentation=https://github.com/coreos/etcd
After=network.target

[Service]
User=root
Type=notify
EnvironmentFile=-/opt/etcd/config/etcd.conf
ExecStart=/opt/etcd/bin/etcd
Restart=on-failure
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload && systemctl enable etcd && systemctl start etcd

/opt/etcd/bin/etcdctl set /coreos.com/network/config '{"Network":"'${FLANNEL_NET}'", "Backend": {"Type": "vxlan"}}'
