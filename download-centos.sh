#!/bin/bash
# centos

VERSION=node-centos-v1.12.0
mkdir -p $VERSION

# Docker
# See https://download.docker.com/linux/centos/7
# See https://centos.pkgs.org/7/centos-x86_64/

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/x86_64/nvidia-docker.repo | \
  sudo tee /etc/yum.repos.d/nvidia-docker.repo

sudo yum update
sudo yum install --downloadonly --downloaddir=./ nvidia-docker2

# Kubernetes
# See https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64/repodata/primary.xml
# See https://centos.pkgs.org/7/centos-x86_64/
curl -o $VERSION/kubeadm-1.12.0-0.x86_64.rpm https://packages.cloud.google.com/yum/pool/c07649bdb3bd346d55cdb4b786f3e6076f1511834bbb41d94e5f380a0c41a9af-kubeadm-1.12.0-0.x86_64.rpm
curl -o $VERSION/kubectl-1.12.0-0.x86_64.rpm https://packages.cloud.google.com/yum/pool/c49bc7ad8a3cc689bc3c722c8d7530f7dc1fa4bc2e3682db15e4c9de321936ac-kubectl-1.12.0-0.x86_64.rpm
curl -o $VERSION/kubelet-1.12.0-0.x86_64.rpm https://packages.cloud.google.com/yum/pool/d8a3f7394ecf1cba6d7ca2c13775a0b64ba927fcc7b4d741b03a9d3c23efd484-kubelet-1.12.0-0.x86_64.rpm
curl -o $VERSION/kubernetes-cni-0.6.0-0.x86_64.rpm https://packages.cloud.google.com/yum/pool/fe33057ffe95bfae65e2f269e1b05e99308853176e24a4d027bc082b471a07c0-kubernetes-cni-0.6.0-0.x86_64.rpm\
curl -o $VERSION/cri-tools-1.12.0-0.x86_64.rpm https://packages.cloud.google.com/yum/pool/53edc739a0e51a4c17794de26b13ee5df939bd3161b37f503fe2af8980b41a89-cri-tools-1.12.0-0.x86_64.rpm
curl -o $VERSION/socat-1.7.3.2-2.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/socat-1.7.3.2-2.el7.x86_64.rpm
