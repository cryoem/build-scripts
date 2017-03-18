#!/usr/bin/env bash

set -x
export PYTHONUNBUFFERED=1

MINICONDA_FILE="Miniconda2-latest-Linux-x86_64.sh"

curl -v -L -O https://repo.continuum.io/miniconda/$MINICONDA_FILE
bash $MINICONDA_FILE -b

# Setup conda
source ${HOME}/miniconda2/bin/activate root
conda config --set show_channel_urls true
