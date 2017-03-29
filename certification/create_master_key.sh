#!/bin/bash

source ../config

cat <<EOF | sudo tee $CA_DIR/server-openssl.cnf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 127.0.0.1
IP.2 = $MASTER_LB_IP
EOF

openssl genrsa -out $CA_DIR/server.key 2048
openssl req -new -key $CA_DIR/server.key -subj "/CN=${MASTER_LB_IP}" -out $CA_DIR/server.csr -config $CA_DIR/server-openssl.cnf
openssl x509 -req -in $CA_DIR/server.csr -CA $CA_DIR/ca.crt -CAkey $CA_DIR/ca.key -CAcreateserial -out $CA_DIR/server.crt -days 10000 -extensions v3_req  -extfile $CA_DIR/server-openssl.cnf
openssl x509 -noout -text -in $CA_DIR/server.crt
