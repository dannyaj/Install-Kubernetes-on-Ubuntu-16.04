#!/bin/bash

source ../config

mkdir -p $CA_DIR 
 
openssl genrsa -out $CA_DIR/ca.key 2048
openssl req -x509 -new -nodes -key $CA_DIR/ca.key -subj "/CN=kube-system" -days 10000 -out $CA_DIR/ca.crt
 
