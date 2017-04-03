#!/usr/bin/env bash

if [ $# -ne 2 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [docker-image] [workspace-root-dir]"'\033[0m'
    echo
    exit 1
fi

docker_image=$1
root_dir=$(cd $2; pwd -P)

sudo docker info

cat << EOF | sudo docker run -i \
                        -v "$root_dir":/workspace \
                        -a stdin -a stdout -a stderr \
                        $docker_image \
                        bash

bash /workspace/eman2/docker/docker_script.sh

EOF
