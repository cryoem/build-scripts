#!/usr/bin/env bash

if [ $# -ne 3 ];then
    printf "\e\033[35m\n  Usage: $(basename ${0})   %s   %s   %s\033[0m\n\n" "eman-recipe-dir" "output-dir" "construct.yaml-dir" >&2
    exit 64
fi

set -xe

EMAN_RECIPE_DIR=$1
OUTPUT_DIR=$2
CONSTRUCT_YAML_DIR=$3

export PYTHONUNBUFFERED=1
source activate root

if [ "$(uname -s)" == "Linux" ];then
    CONDA_BUILD_NUMPY_OPT="--numpy 1.8"
fi

# Build eman recipe
conda build ${EMAN_RECIPE_DIR} -c cryoem -c defaults -c conda-forge ${CONDA_BUILD_NUMPY_OPT}

# Package eman
mkdir -p ${OUTPUT_DIR} && cd ${OUTPUT_DIR}

CONSTRUCT_YAML="${CONSTRUCT_YAML_DIR}/construct.yaml"
CONDA_PREFIX_NEW=$(echo ${CONDA_PREFIX} | sed "s~^/\(.\)/~\1:/~")
sed -i.bak "s~\(^.*file://\)\(.*$\)~\1${CONDA_PREFIX_NEW}/conda-bld/~" ${CONSTRUCT_YAML}
cat ${CONSTRUCT_YAML}
constructor ${CONSTRUCT_YAML_DIR}
mv ${CONSTRUCT_YAML}.bak ${CONSTRUCT_YAML}
