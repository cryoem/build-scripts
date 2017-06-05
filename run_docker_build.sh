#!/usr/bin/env bash

if [ $# -ne 3 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [docker-image] [eman-repo-dir] [output-volumes-dir]"'\033[0m'
    echo
    exit 1
fi

set -xe

docker_image=$1
eman_repo_dir=$(cd $2 && pwd -P)
output_volumes_dir=$(cd $3 && pwd -P)
build_scripts_dir=$(cd $(dirname $0) && pwd -P)

docker_build_scripts_dir="/build_scripts"
docker_home_dir="/root"
docker_conda_root="${docker_home_dir}/miniconda2"

dot_conda_dir="${output_volumes_dir}/dot_conda"
conda_bld_dir="${output_volumes_dir}/conda-bld"
pkgs_dir="${output_volumes_dir}/pkgs"
installers_dir="${output_volumes_dir}"

mkdir -p "${dot_conda_dir}"
mkdir -p "${conda_bld_dir}"
mkdir -p "${pkgs_dir}"
mkdir -p "${installers_dir}"


docker_dot_conda_dir="${docker_home_dir}/.conda/"
docker_conda_bld_dir="${docker_conda_root}/conda-bld"
docker_pkgs_dir="${docker_conda_root}/pkgs"
docker_eman_repo_dir="/eman_repo_dir"
docker_installers_dir="/installers_dir"




docker info

HOST_UID=$(id -u)
HOST_GID=$(id -g)

docker run -i \
            -v "$build_scripts_dir":"$docker_build_scripts_dir" \
            -v "$dot_conda_dir":"$docker_dot_conda_dir" \
            -v "$conda_bld_dir":"$docker_conda_bld_dir" \
            -v "$pkgs_dir":"$docker_pkgs_dir" \
            -v "$eman_repo_dir":"$docker_eman_repo_dir" \
            -v "$installers_dir":"$docker_installers_dir" \
            -a stdin -a stdout -a stderr \
            $docker_image \
            bash << EOF

set -ex

bash "${docker_build_scripts_dir}"/build_and_package.sh \
                                "${docker_eman_repo_dir}"/recipes/eman \
                                "${docker_installers_dir}" \
                                "${docker_build_scripts_dir}"/constructor

EOF
