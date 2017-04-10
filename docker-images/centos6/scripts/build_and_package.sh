#!/usr/bin/env bash

if [ $# -ne 3 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [eman-repository-dir] [output-dir] [construct.yaml-dir]"'\033[0m'
    echo
    exit 1
fi

set -x

EMAN_REPO_DIR=$1
OUTPUT_DIR=$2
CONSTRUCT_YAML_DIR=$3

# Build eman recipe
conda build ${EMAN_REPO_DIR}/recipes/eman -c cryoem -c defaults -c conda-forge

# Package eman
mkdir -p ${OUTPUT_DIR} && cd ${OUTPUT_DIR}
cp -a ${CONSTRUCT_YAML_DIR}/ .
sed -i.bak "s~\(^.*file://\)\(.*$\)~\1${CONDA_PREFIX}/conda-bld/~" construct.yaml
constructor .
