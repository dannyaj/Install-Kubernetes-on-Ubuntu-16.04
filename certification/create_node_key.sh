#!/bin/bash

source ../config

cat <<EOF | sudo tee $CA_DIR/node-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = $NODE_IP
EOF

openssl genrsa -out $CA_DIR/node.key 2048
openssl req -new -key $CA_DIR/node.key -subj "/CN=$NODE_IP" -out $CA_DIR/node.csr -config $CA_DIR/node-openssl.cnf
openssl x509 -req -in $CA_DIR/node.csr -CA $CA_DIR/ca.crt -CAkey $CA_DIR/ca.key -CAcreateserial -out $CA_DIR/node.crt -days 10000 -extensions v3_req -extfile $CA_DIR/node-openssl.cnf
openssl x509 -noout -text -in $CA_DIR/node.crt

cat <<EOF | sudo tee $CA_DIR/kubeconfig
apiVersion: v1
kind: Config
clusters:
- name: local
  cluster:
    certificate-authority: /srv/kubernetes/ca.crt
users:
- name: kube-node
  user:
    client-certificate: /srv/kubernetes/node.crt
    client-key: /srv/kubernetes/node.key
contexts:
- context:
    cluster: local
    user: kube-node
  name: kubelet-context
current-context: kubelet-context
EOF
