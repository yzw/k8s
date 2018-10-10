#!/bin/bash

# Disabling SELinux
sudo setenforce 0

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
# see https://docs.docker.com/install/linux/docker-ce/centos
# sudo yum remove docker \
#     docker-client \
#     docker-client-latest \
#     docker-common \
#     docker-latest \
#     docker-latest-logrotate \
#     docker-logrotate \
#     docker-selinux \
#     docker-engine-selinux \
#     docker-engine

sudo yum install -y audit-libs-python-2.8.1-3.el7_5.1.x86_64.rpm \
    checkpolicy-2.5-6.el7.x86_64.rpm \
    container-selinux-2.68-1.el7.noarch.rpm \
    docker-ce-18.06.1.ce-3.el7.x86_64.rpm \
    libcgroup-0.41-15.el7.x86_64.rpm \
    libnvidia-container-tools-1.0.0-1.x86_64.rpm \
    libnvidia-container1-1.0.0-1.x86_64.rpm \
    libseccomp-2.3.1-3.el7.x86_64.rpm \
    libsemanage-python-2.5-11.el7.x86_64.rpm \
    nvidia-container-runtime-2.0.0-1.docker18.06.1.x86_64.rpm \
    nvidia-container-runtime-hook-1.4.0-2.x86_64.rpm \
    nvidia-docker2-2.0.3-1.docker18.06.1.ce.noarch.rpm \
    policycoreutils-python-2.5-22.el7.x86_64.rpm \
    python-IPy-0.75-6.el7.noarch.rpm \
    setools-libs-3.3.8-2.el7.x86_64.rpm

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

# Enable ipvs
sudo tee /etc/sysconfig/modules/ipvs.modules <<-'EOF'
#!/bin/bash
ipvs_modules_dir="/usr/lib/modules/`uname -r`/kernel/net/netfilter/ipvs"
for i in `ls \$ipvs_modules_dir | sed  -r 's#(.*).ko.xz#\1#'`; do
    /sbin/modinfo -F filename $i  &> /dev/null
    if [ $? -eq 0 ]; then
        sudo /sbin/modprobe $i
    fi
done
EOF
sudo chmod +x /etc/sysconfig/modules/ipvs.modules 
bash /etc/sysconfig/modules/ipvs.modules

# Install kubernetes
sudo yum install -y kubeadm-1.12.0-0.x86_64.rpm \
    kubectl-1.12.0-0.x86_64.rpm \
    kubelet-1.12.0-0.x86_64.rpm \
    cri-tools-1.12.0-0.x86_64.rpm \
    kubernetes-cni-0.6.0-0.x86_64.rpm \
    socat-1.7.3.2-2.el7.x86_64.rpm

# Start kubelet
sudo systemctl enable kubelet
sudo systemctl start kubelet