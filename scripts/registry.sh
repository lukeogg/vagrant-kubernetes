#!/bin/bash
#
# Common setup for all servers (Control Plane and Nodes)

set -euxo pipefail

# disable swap
sudo swapoff -a

# keeps the swaf off during reboot
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true
sudo apt-get update -y

# Fix too many files error

#sudo sysctl fs.inotify.max_user_watches=524288
#sudo sysctl fs.inotify.max_user_instances=512

#cat << EOF | sudo tee -a /etc/sysctl.conf
#fs.inotify.max_user_watches = 524288
#fs.inotify.max_user_instances = 512
#EOF

# Install docker/containerd Runtime

sudo apt-get update
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# sudo mkdir -p /var/lib/kubelet
# sudo cp /home/vagrant/.docker/config.json /var/lib/kubelet/config.json
# sudo mkdir -p /etc/docker/
# sudo cp /home/vagrant/daemon.json /etc/docker/daemon.json

echo "Docker/containerd runtime installed susccessfully"

sudo docker run -d --restart=always -p 5000:5000 --name "registry-mirror" -v /registry:/var/lib/registry registry:2 /var/lib/registry/config.yml