#!/bin/bash
#
# Setup for GPU Drivers

set -euxo pipefail

distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
wget https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-keyring_1.0-1_all.deb
dpkg -i cuda-keyring_1.0-1_all.deb

apt-get update
apt-get -y install cuda-drivers

nvidia-smi
