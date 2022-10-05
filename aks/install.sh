#!/bin/bash -v

sudo -i

apt update
apt install -y docker.io
apt install -y conntrack socat
apt install -y zip
apt install -y jq
apt install -y w3m w3m-img
swapoff -a
systemctl start docker
systemctl enable docker
usermod -a -G docker azureuser

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | sudo bash


