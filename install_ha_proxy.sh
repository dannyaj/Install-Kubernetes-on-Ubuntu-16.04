#!/bin/bash

source config 

cat <<EOF > /opt/haproxy.cfg
global
        log 127.0.0.1 local0
        log 127.0.0.1 local1 notice
        maxconn 4096
        maxpipes 1024
        daemon

defaults
        log     global
        mode    tcp
        option  tcplog
        option  dontlognull
        option  redispatch
        option http-server-close
        retries 3
        timeout connect 5000
        timeout client 50000
        timeout server 50000

frontend default_frontend
        bind *:8080
        default_backend master-cluster

backend master-cluster
        server master1 $MASTER_1_IP
        server master2 $MASTER_2_IP
EOF

docker run -d --name master-proxy \
-v /opt/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro \
--net=host haproxy

