#!/bin/bash
sudo docker pull k8s.gcr.io/kube-proxy:v1.12.0
sudo docker pull k8s.gcr.io/pause:3.1
sudo docker pull quay.io/coreos/flannel:v0.10.0-amd64
sudo docker pull busybox:1.29

sudo docker tag quay.io/coreos/flannel:v0.10.0-amd64 quay.io/coreos/flannel:v0.10.0

sudo docker pull k8s.gcr.io/etcd:3.2.24
sudo docker pull k8s.gcr.io/kube-scheduler:v1.12.0
sudo docker pull k8s.gcr.io/kube-controller-manager:v1.12.0
sudo docker pull k8s.gcr.io/kube-apiserver:v1.12.0
sudo docker pull k8s.gcr.io/coredns:1.2.2

IMAGES=node-centos-v1.12.0/images
sudo docker save k8s.gcr.io/kube-proxy:v1.12.0 -o $IMAGES/kube-proxy.tar
sudo docker save k8s.gcr.io/pause:3.1 -o $IMAGES/pause.tar
sudo docker save quay.io/coreos/flannel:v0.10.0 -o $IMAGES/flannel.tar
sudo docker save busybox:1.29 -o $IMAGES/busybox.tar

IMAGES=node-ubuntu-v1.12.0/images
sudo docker save k8s.gcr.io/kube-proxy:v1.12.0 -o $IMAGES/kube-proxy.tar
sudo docker save k8s.gcr.io/pause:3.1 -o $IMAGES/pause.tar
sudo docker save quay.io/coreos/flannel:v0.10.0 -o $IMAGES/flannel.tar
sudo docker save busybox:1.29 -o $IMAGES/busybox.tar

IMAGES=master/images
sudo docker save k8s.gcr.io/etcd:3.2.24 -o $IMAGES/etcd.tar
sudo docker save k8s.gcr.io/kube-scheduler:v1.12.0 -o $IMAGES/kube-scheduler.tar
sudo docker save k8s.gcr.io/kube-controller-manager:v1.12.0 -o $IMAGES/kube-controller-manager.tar
sudo docker save k8s.gcr.io/kube-apiserver:v1.12.0 -o $IMAGES/kube-apiserver.tar
sudo docker save k8s.gcr.io/coredns:1.2.2 -o $IMAGES/coredns.tar

# addons
sudo docker pull k8s.gcr.io/kubernetes-dashboard:v1.10.0
sudo docker pull quay.io/coreos/kube-state-metrics:v1.4.0
sudo docker pull k8s.gcr.io/addon-resizer:1.7
sudo docker pull grafana/grafana:5.2.4
sudo docker pull prom/alertmanager:v0.14.0
sudo docker pull prom/prometheus:v2.4.0


IMAGES=deploy/admin/images
sudo docker save k8s.gcr.io/kubernetes-dashboard:v1.10.0 -o $IMAGES/kubernetes-dashboard.tar
sudo docker save quay.io/coreos/kube-state-metrics:v1.4.0 -o $IMAGES/kube-state-metrics.tar
sudo docker save k8s.gcr.io/addon-resizer:1.7 -o $IMAGES/addon-resizer.tar
sudo docker save grafana/grafana:5.2.4 -o $IMAGES/grafana.tar
sudo docker save prom/alertmanager:v0.14.0 -o $IMAGES/alertmanager.tar
sudo docker save prom/prometheus:v2.4.0 -o $IMAGES/prometheus.tar