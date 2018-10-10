#!/bin/bash

# Disable swap
sudo swapoff -a
sudo sed -i 's/.*swap.*/#&/' /etc/fstab

# Bridge iptables
sudo tee /etc/sysctl.d/k8s.conf <<-'EOF'
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

# Install docker
# See https://docs.docker.com/install/linux/docker-ce/ubuntu
# See https://packages.ubuntu.com/
# sudo apt-get remove docker docker-engine docker.io docker-ce

sudo dpkg -i aufs-tools_1%3a3.2+20130722-1.1ubuntu1_amd64.deb \
    cgroupfs-mount_1.2_all.deb \
    docker-ce_18.06.1~ce~3-0~ubuntu_amd64.deb \
    git-man_1%3a2.7.4-0ubuntu1.4_all.deb \
    git_1%3a2.7.4-0ubuntu1.4_amd64.deb \
    liberror-perl_0.17-1.2_all.deb \
    libltdl7_2.4.6-0.1_amd64.deb \
    libnvidia-container-tools_1.0.0-1_amd64.deb \
    libnvidia-container1_1.0.0-1_amd64.deb \
    nvidia-container-runtime-hook_1.4.0-1_amd64.deb \
    nvidia-container-runtime_2.0.0+docker18.06.1-1_amd64.deb \
    nvidia-docker2_2.0.3+docker18.06.1-1_all.deb \
    pigz_2.3.1-2_amd64.deb

sudo rm -f /etc/docker/daemon.json
    
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

# Load images
IMAGES=images
sudo docker load -i $IMAGES/busybox.tar
sudo docker load -i $IMAGES/kube-proxy.tar
sudo docker load -i $IMAGES/flannel.tar
sudo docker load -i $IMAGES/pause.tar

# Install kubernetes
sudo dpkg -i kubeadm_1.12.0-00_amd64.deb \
    kubectl_1.12.0-00_amd64.deb \
    kubelet_1.12.0-00_amd64.deb \
    kubernetes-cni_0.6.0-00_amd64.deb \
    cri-tools_1.12.0-00_amd64.deb \
    socat_1.7.3.1-1_amd64.deb \
    ebtables_2.0.10.4-3.4ubuntu1_amd64.deb \
    ethtool_4.5-1_amd64.deb

# Start kubelet
sudo systemctl enable kubelet
sudo systemctl start kubelet