#!/usr/bin/env bash

# If a single directory is given, the following structure is assumed:
#
# workspace-root-dir/
#                     docker_volumes/dot_conda/           # .conda dir for constructor cache ???
#                     docker_volumes/conda_dir/
#                                             conda-bld/  # for caching
#                                             pkgs/       # for caching
#                     eman2/recipes/eman/                 # eman recipe dir
#                     cenots6/                            # output dir for installer
#
# scripts_root_dir/                                       # scripts dir, = CWD/..
#                 constructor/                            # construct.yaml dir

if [ $# -ne 2 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [docker-image] [cache-dir]"'\033[0m'
    echo
    exit 1
fi

docker_image=$1
cache_dir=$2
build_scripts_dir=$(cd $(dirname $0)/../..; pwd -P)

docker_workspace_dir="/workspace"
docker_build_scripts_dir="/build_scripts"
docker_home_dir="/root"
docker_conda_root="${docker_home_dir}/miniconda2"

dot_conda_dir=${cache_dir}/dot_conda
conda_bld_dir=${cache_dir}/conda-bld
pkgs_dir=${cache_dir}/pkgs
installers_dir="${cache_dir}/installers"


docker_dot_conda_dir=${docker_home_dir}/.conda/
docker_conda_bld_dir=${docker_conda_root}/conda-bld
docker_pkgs_dir=${docker_conda_root}/pkgs




docker info

HOST_UID=$(id -u)
HOST_GID=$(id -g)

docker run -i \
            -v "$build_scripts_dir":"$docker_build_scripts_dir" \
            -v "$dot_conda_dir":"$docker_dot_conda_dir" \
            -v "$conda_bld_dir":"$docker_conda_bld_dir" \
            -v "$pkgs_dir":"$docker_pkgs_dir" \
            -a stdin -a stdout -a stderr \
            $docker_image \
            bash << EOF

set -ex
export PYTHONUNBUFFERED=1
source activate root

bash "${docker_build_scripts_dir}"/docker-images/scripts/build_and_package.sh \
                                "$docker_workspace_dir"/eman2/recipes/eman \
                                "${installers_dir}" \
                                "${docker_build_scripts_dir}"/constructor

chown -v $HOST_GID:$HOST_UID "${installers_dir}"/*

EOF
