#!/usr/bin/env bash

EMAN_REPO_DIR="/workspace/eman2"
OUTPUT_DIR="/workspace/centos6"
CONSTRUCT_YAML_DIR="/workspace/build-scripts/constructor"

set -x
export PYTHONUNBUFFERED=1

bash dockerfile.sh
bash build_and_package.sh ${EMAN_REPO_DIR} ${OUTPUT_DIR} ${CONSTRUCT_YAML_DIR}
