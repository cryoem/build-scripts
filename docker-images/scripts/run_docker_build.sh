#!/usr/bin/env bash

if [ $# -ne 2 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [docker-image] [workspace-root-dir]"'\033[0m'
    echo
    exit 1
fi

docker_image=$1
root_dir=$(cd $2; pwd -P)
scripts_root_dir=$(cd $(dirname $0)/..; pwd -P)

docker_root_dir="/workspace"
docker_scripts_root_dir="/scripts_root"

dot_conda_dir=${root_dir}/docker_volumes/dot_conda
docker_dot_conda_dir=/root/.conda/

conda_dir=${root_dir}/docker_volumes/conda_dir

conda_bld_dir=${conda_dir}/conda-bld
docker_conda_bld_dir=/root/miniconda2/conda-bld

pkgs_dir=${conda_dir}/pkgs
docker_pkgs_dir=/root/miniconda2/pkgs


docker info

docker run -i \
            -v "$root_dir":"$docker_root_dir" \
            -v "$scripts_root_dir":"$docker_scripts_root_dir" \
            -v "$dot_conda_dir":"$docker_dot_conda_dir" \
            -v "$conda_bld_dir":"$docker_conda_bld_dir" \
            -v "$pkgs_dir":"$docker_pkgs_dir" \
            -a stdin -a stdout -a stderr \
            $docker_image \
            bash << EOF

set -x
export PYTHONUNBUFFERED=1

bash dockerfile.sh
bash "${docker_scripts_root_dir}"/scripts/build_and_package.sh \
                                "$docker_root_dir"/eman2 \
                                "$docker_root_dir"/centos6 \
                                "${docker_scripts_root_dir}"/constructor

EOF
