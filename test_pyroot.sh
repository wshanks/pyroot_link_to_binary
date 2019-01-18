#!/usr/bin/env bash
set -e
cd ~

# Set up conda
if [ ! -d miniconda3 ]; then
    bash ~/miniconda.sh -b
fi
source ~/miniconda3/etc/profile.d/conda.sh 
set +e
conda create --yes -n root-test python numpy
set -e

# Set up ROOT
rm -rf root-bin
mkdir root-bin
tar xf $PWD/root-bin.tar.gz  --strip-components=1 -C root-bin
rm -rf root-src
mkdir root-src
tar xf $PWD/root-src.tar.gz --strip-components=1 -C root-src

# Set environment
conda activate root-test
set +e
source ~/root-bin/bin/thisroot.sh 
set -e

pushd pyroot
cp -r ~/root-src/bindings/pyroot/* .
make clean && make
popd

export PYTHONPATH=$HOME/pyroot:$PYTHONPATH
python test_pyroot.py
