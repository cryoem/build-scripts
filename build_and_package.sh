#!/usr/bin/env bash

if [ $# -ne 3 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [eman-recipe-dir] [output-dir] [construct.yaml-dir]"'\033[0m'
    echo
    exit 1
fi

set -xe

EMAN_RECIPE_DIR=$1
OUTPUT_DIR=$2
CONSTRUCT_YAML_DIR=$3

export PYTHONUNBUFFERED=1
source activate root

# Build eman recipe
conda build ${EMAN_RECIPE_DIR} -c cryoem -c defaults -c conda-forge

# Package eman
mkdir -p ${OUTPUT_DIR} && cd ${OUTPUT_DIR}

CONSTRUCT_YAML="${CONSTRUCT_YAML_DIR}/construct.yaml"
sed -i.bak "s~\(^.*file://\)\(.*$\)~\1${CONDA_PREFIX}/conda-bld/~" ${CONSTRUCT_YAML}
constructor ${CONSTRUCT_YAML_DIR}
mv ${CONSTRUCT_YAML}.bak ${CONSTRUCT_YAML}