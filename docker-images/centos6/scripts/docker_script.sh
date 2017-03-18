#!/usr/bin/env bash

EMAN_REPO_DIR="/workspace/eman2"
OUTPUT_DIR="/workspace/centos6"
CONSTRUCT_YAML_DIR="/workspace/build-scripts/constructor"

set -x
export PYTHONUNBUFFERED=1

yum install -y \
               gcc gcc-c++ \
               mesa-libGLU-devel \
               libXext-devel \
               libXrender-devel \
               libSM-devel \
               libX11-devel && \
yum clean all

MINICONDA_FILE="Miniconda2-latest-Linux-x86_64.sh"

curl -v -L -O https://repo.continuum.io/miniconda/$MINICONDA_FILE
bash $MINICONDA_FILE -b

# Setup conda
source ${HOME}/miniconda2/bin/activate root
conda config --set show_channel_urls true

conda install conda-build constructor --yes

# Install constructor that is customized for eman
curl -v -L https://github.com/cryoem/constructor/archive/eman.tar.gz -o constructor-eman.tar.gz
tar xzvf constructor-eman.tar.gz

cd constructor-eman/
python setup.py install

# Build eman recipe
conda build ${EMAN_REPO_DIR}/recipes/eman -c cryoem -c defaults -c conda-forge

# Package eman
mkdir -p ${OUTPUT_DIR} && cd ${OUTPUT_DIR}
cp -a ${CONSTRUCT_YAML_DIR}/ .
sed -i.bak "s~\(^.*file://\)\(.*$\)~\1${CONDA_PREFIX}/conda-bld/~" construct.yaml
constructor .
