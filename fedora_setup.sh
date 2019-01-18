#!/usr/bin/env bash
set -e
mkdir -p data container

if [ ! -f data/miniconda.sh ]; then
    curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o data/miniconda.sh
fi
if [ ! -f data/root-src.tar.gz ]; then
    curl -L https://root.cern.ch/download/root_v6.14.06.source.tar.gz -o data/root-src.tar.gz
fi
if [ ! -f data/root-bin.tar.gz ]; then
    curl -L https://root.cern.ch/download/root_v6.14.06.Linux-fedora28-x86_64-gcc8.2.tar.gz -o data/root-bin.tar.gz
fi

# Create container with necessary dependencies:
# 1. system requirements
# 2. conda installer requirements
# 3. PyROOT compilation requirements (outside of pre-compiled ROOT)
# 4. ROOT runtime requirements
# 5. X11 requirements for opening windows in host system
sudo dnf --releasever=28 --installroot=$PWD/container install --assumeyes \
    systemd passwd dnf fedora-release \
    tar bzip2 \
    gcc-c++ make \
    libtiff-devel giflib-devel tbb-devel \
    libSM libX11 libXext libXpm libXft

sudo cp data/* $PWD/container/root
sudo mkdir -p $PWD/container/root/pyroot
sudo cp Makefile $PWD/container/root/pyroot
sudo cp test_pyroot.sh $PWD/container/root
sudo cp test_pyroot.py $PWD/container/root

set +e
sudo semanage fcontext -a -t container_file_t "$PWD/container(/.*)?"
set -e
sudo restorecon -R $PWD/container

sudo systemd-nspawn --setenv=DISPLAY=$DISPLAY --setenv=XAUTHORITY=$XAUTHORITY --bind-ro=/tmp/.X11-unix --bind-ro=$HOME -D $PWD/container bash /root/test_pyroot.sh
