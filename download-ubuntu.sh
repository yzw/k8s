#!/bin/bash
# ubuntu

VERSION=node-ubuntu-v1.12.0
mkdir -p $VERSION

# Docker
# See https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt update
sudo rm -rf /var/cache/apt/archives/*.deb
sudo apt install -dy nvidia-docker2
cp /var/cache/apt/archives/*.deb ./$VERSION/

# Kubernetes
# See https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages
# See https://packages.ubuntu.com
curl -o $VERSION/kubeadm_1.12.0-00_amd64.deb https://packages.cloud.google.com/apt/pool/kubeadm_1.12.0-00_amd64_db6058f8d51e8d4f06998ec6adbdf635c394ab9153b35a0b1872e8981e67154a.deb
curl -o $VERSION/kubectl_1.12.0-00_amd64.deb https://packages.cloud.google.com/apt/pool/kubectl_1.12.0-00_amd64_242af67011dc074d0683131d96c22eb586f44553d0626767f0313d1eb8dc2b9f.deb
curl -o $VERSION/kubelet_1.12.0-00_amd64.deb https://packages.cloud.google.com/apt/pool/kubelet_1.12.0-00_amd64_24f580dcc7cb8cb8439da40c2e1488f1851dac9dfaac0b64b94492538e59f948.deb
curl -o $VERSION/kubernetes-cni_0.6.0-00_amd64.deb https://packages.cloud.google.com/apt/pool/kubernetes-cni_0.6.0-00_amd64_43460dd3c97073851f84b32f5e8eebdc84fadedb5d5a00d1fc6872f30a4dd42c.deb
curl -o $VERSION/cri-tools_1.12.0-00_amd64.deb https://packages.cloud.google.com/apt/pool/cri-tools_1.12.0-00_amd64_2d9f048a50a9dfeceebd84635f1322955aca6381d9c05b4d60b3da1edb7d856c.deb
curl -o $VERSION/socat_1.7.3.1-1_amd64.deb http://kr.archive.ubuntu.com/ubuntu/pool/universe/s/socat/socat_1.7.3.1-1_amd64.deb
curl -o $VERSION/ebtables_2.0.10.4-3.4ubuntu1_amd64.deb http://kr.archive.ubuntu.com/ubuntu/pool/main/e/ebtables/ebtables_2.0.10.4-3.4ubuntu1_amd64.deb
curl -o $VERSION/ethtool_4.5-1_amd64.deb http://kr.archive.ubuntu.com/ubuntu/pool/main/e/ethtool/ethtool_4.5-1_amd64.deb