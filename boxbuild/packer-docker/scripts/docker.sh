#!/bin/sh -eux

yum install -y docker
echo '
{
    "bip": "172.18.0.1/16"
}' > /etc/docker/daemon.json
systemctl restart docker
systemctl enable docker
docker pull percona/pmm-server:2
