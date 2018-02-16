#!/usr/bin/env bash

if [ $# -ne 3 ];then
    printf "\e\033[35m\n  Usage: $(basename ${0})   %s   %s   %s\033[0m\n\n" "eman-recipe-dir" "output-dir" "construct.yaml-dir" >&2
    exit 64
fi

set -xe

EMAN_RECIPE_DIR=${WORKSPACE}/recipes/eman
OUTPUT_DIR=$2
CONSTRUCT_YAML_DIR=$3

export PYTHONUNBUFFERED=1
source activate root

# Build eman recipe
conda info -a
conda render ${EMAN_RECIPE_DIR}
conda build purge-all
conda build ${EMAN_RECIPE_DIR} -c cryoem -c defaults -c conda-forge

# Package eman
cd ${OUTPUT_DIR}
pwd
ls

ls ${CONSTRUCT_YAML_DIR}

CONSTRUCT_YAML="${CONSTRUCT_YAML_DIR}/construct.yaml"
cat ${CONSTRUCT_YAML}
constructor --clean -v --cache-dir=${HOME_DIR}/.conda/constructor
constructor ${CONSTRUCT_YAML_DIR} -v --cache-dir=${HOME_DIR}/.conda/constructor
