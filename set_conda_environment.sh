#!/usr/bin/env bash

case $1 in
    'centos6') os_label="Linux"   ;;
    'centos7') os_label="Linux"   ;;
    'mac')     os_label="MacOSX"  ;;
    'win')     os_label="Windows" ;;
esac

MINICONDA_FILE="Miniconda2-latest-${os_label}-x86_64.sh"

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
