## master
```bash

# init
sudo kubeadm init --kubernetes-version=v1.12.0 --pod-network-cidr=100.0.0.0/8 --apiserver-advertise-address=x.x.x.x --apiserver-cert-extra-sans=x.x.x.x

# create master
kubectl taint nodes $(hostname | tr A-Z a-z) node-role.kubernetes.io/master=:NoSchedule
kubectl get nodes $(hostname | tr A-Z a-z) -o yaml | sed 's/labels:/labels:\n    node-role\.kubernetes\.io\/master: ""/' | kubectl replace -f -
kubeadm alpha phase bootstrap-token cluster-info
kubectl create clusterrolebinding kubeadm:kubelet-bootstrap --clusterrole=system:node-bootstrapper --group=system:bootstrappers:kubeadm:default-node-token

export PRIVATE_IP=$(ip addr show eth0 | grep -Po 'inet \K[\d.]+')
export PUBLIC_IP=x.x.x.x
kubectl -n kube-public get cm cluster-info -o yaml | sed 's/'$PRIVATE_IP'/'$PUBLIC_IP'/' | kubectl replace -f -

# token
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-token | awk '{print $1}')

sudo kubeadm token create $(sudo kubeadm token generate) --print-join-command --ttl=24h
sudo kubeadm token list

kubectl get nodes yzw-centos -o yaml | sed 's/labels:/labels:\n    node-role\.kubernetes\.io\/node: ""/' | kubectl replace -f -
kubectl get nodes yzw-ubuntu -o yaml | sed 's/labels:/labels:\n    node-role\.kubernetes\.io\/node: ""/' | kubectl replace -f -

# approve node join to master
kubectl get csr
kubectl certificate approve ${CSR_NAME}

# docker private registry
kubectl -n {{PROJECT}} create secret docker-registry {{SECRET_NAME}} --docker-server={{REGISTRY} --docker-username={{USERNAME} --docker-password={{PASSWORD} --docker-email={{EMAIL}

# etcd
export ETCDCTL_API=3
export ETCDCTL_CACERT=/etc/kubernetes/pki/ca.crt
export ETCDCTL_CERT=/etc/kubernetes/pki/apiserver.crt
export ETCDCTL_KEY=/etc/kubernetes/pki/apiserver.key
export ETCDCTL_ENDPOINTS=x.x.x.x:2379

# etcdctl member list
# fields, json, protobuf, simple, table
etcdctl endpoint status -w table
etcdctl get --prefix=true --keys-only=true "" -w fields

# crt to keystore
openssl pkcs12 -export -in admin.crt -inkey admin.key -out admin.p12 -name admin
keytool -importkeystore -srckeystore admin.p12 -srcstoretype PKCS12 -destkeystore admin.keystore
```


## node
```bash
# join
sudo kubeadm join x.x.x.x:6443 --token bgc7nm.nm5m4rbe0bmlca9q --discovery-token-ca-cert-hash sha256:27325b77f2f78254f87659c9a176c75a277bd86b9c4ff7b3655994d1e80d4c94

# override hostname
sudo sed -i "s/kubelet.conf\"/kubelet.conf --hostname-override=${HOSTNAME}\"/" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# nvidia-docker
sudo tee /etc/docker/daemon.json <<-'EOF'
{
    "default-runtime":"nvidia",
    "registry-mirrors": ["https://registry.cn-hangzhou.aliyuncs.com"],
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF

# reset
sudo kubeadm reset -f
sudo ip link delete kube-bridge
sudo ip link delete kube-dummy-if
sudo ip link delete dummy0
ip route show|grep '100\.0\.' | awk '{print $1}' | sudo xargs ip route flush
sudo rm -rf /var/lib/etcd
sudo rm -rf /data/etcd/*
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /var/lib/cni/networks/kubernetes/*
```
