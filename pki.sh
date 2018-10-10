#!/bin/bash

# Install cfssl
# sudo curl -o /usr/local/bin/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
# sudo curl -o /usr/local/bin/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
# sudo curl -o /usr/local/bin/cfssl-certinfo https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64
# sudo chmod +x /usr/local/bin/cfssl*

# Go install
# go get -u github.com/cloudflare/cfssl/cmd/cmd/cfssl
# go get -u github.com/cloudflare/cfssl/cmd/cfssljson
# go get -u github.com/cloudflare/cfssl/cmd/cfssl-certinfo

# example
# cfssl print-defaults config > config/ca-config.json
# cfssl print-defaults csr > config/ca-csr.json
# cfssl print-defaults csr > config/client.json

# Generating self-signed root CA certificate and private key
NAME=k8s
mkdir -p pki/$NAME
cd pki/$NAME
cfssl gencert -initca ../config/ca-csr.json | cfssljson -bare ca

# Generate the apiserver certificates
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../config/ca-config.json -profile=kubernetes ../config/apiserver.json | cfssljson -bare apiserver

# Generate the admin certificates
cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=../config/ca-config.json -profile=kubernetes ../config/admin.json | cfssljson -bare admin

# Generate the service account
openssl genrsa -out sa.key
openssl rsa -in sa.key -pubout -out sa.pub

# Move
mkdir -p pki
cp sa.* pki/
cp *.pem pki/

# Rename
cd pki
for file in `ls . | grep '\-key.pem'`
do
  mv $file ${file/-key.pem/.key}
done

for file in `ls . | grep '\.pem'`
do
  mv $file ${file/.pem/.crt}
done

# Rewiew
cfssl-certinfo -cert apiserver.crt

cd ../../../
cp -r pki/$NAME/pki master/kubernetes