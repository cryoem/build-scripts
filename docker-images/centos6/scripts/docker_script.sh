#!/usr/bin/env bash

EMAN_REPO_DIR="/workspace/eman2"
OUTPUT_DIR="/workspace/centos6"
CONSTRUCT_YAML_DIR="/workspace/build-scripts/constructor"

set -x
export PYTHONUNBUFFERED=1

bash dockerfile.sh

# Build eman recipe
conda build ${EMAN_REPO_DIR}/recipes/eman -c cryoem -c defaults -c conda-forge

# Package eman
mkdir -p ${OUTPUT_DIR} && cd ${OUTPUT_DIR}
cp -a ${CONSTRUCT_YAML_DIR}/ .
sed -i.bak "s~\(^.*file://\)\(.*$\)~\1${CONDA_PREFIX}/conda-bld/~" construct.yaml
constructor .
