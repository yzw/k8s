#!/bin/bash

# Disable firewalld(optional)
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Enable IP forward
echo "enable ipv4 forward"
sudo tee /proc/sys/net/ipv4/ip_forward <<-'EOF'
1
EOF

# Load images
IMAGES=images
sudo docker load -i $IMAGES/etcd-amd64.tar
sudo docker load -i $IMAGES/kube-apiserver-amd64.tar
sudo docker load -i $IMAGES/kube-controller-manager-amd64.tar
sudo docker load -i $IMAGES/kube-scheduler-amd64.tar
sudo docker load -i $IMAGES/coredns.tar

# Replace IP
PRIVATE_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
PUBLIC_IP=${PRIVATE_IP}

# kubernetes/*.conf
sed -i "s/{{PRIVATE_IP}}/$PRIVATE_IP/g" kubernetes/admin.conf
# kubernetes/manifests
sed -i "s/{{PRIVATE_IP}}/$PRIVATE_IP/g" kubernetes/manifests/*
sed -i "s/{{PUBLIC_IP}}/$PUBLIC_IP/g" kubernetes/manifests/*
# addons
sed -i "s/{{PUBLIC_IP}}/$PUBLIC_IP/g" addons/*

# Config pki and manifests
sed -i "s/{{CA}}/`echo $(cat kubernetes/pki/ca.crt|base64|tr -d '\n')`/" kubernetes/admin.conf
sed -i "s/{{CLIENT_CRT}}/`echo $(cat kubernetes/pki/admin.crt|base64|tr -d '\n')`/" kubernetes/admin.conf
sed -i "s/{{CLIENT_KEY}}/`echo $(cat kubernetes/pki/admin.key|base64|tr -d '\n')`/" kubernetes/admin.conf

# Config pki and manifests
sudo mkdir -p /data/etcd
sudo mkdir -p /var/lib/kubelet/
sudo cp -r kubelet/* /var/lib/kubelet/
sudo cp -r kubernetes /etc/
sudo ln -sf /etc/kubernetes/admin.conf /etc/kubernetes/kubelet.conf

mkdir -p $HOME/.kube
sudo cp -r /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Run kubelet
sudo systemctl enable kubelet
sudo systemctl daemon-reload
sudo systemctl start kubelet