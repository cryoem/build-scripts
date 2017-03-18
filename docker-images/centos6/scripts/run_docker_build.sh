#!/usr/bin/env bash

docker_image=$1
sudo docker info

cat << EOF | sudo docker run -i \
                        -v $HOME/workspace:/workspace \
                        -a stdin -a stdout -a stderr \
                        $docker_image \
                        bash

bash /workspace/eman2/docker/docker_script.sh

EOF
