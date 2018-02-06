#!/usr/bin/env bash

if [ $# -ne 3 ];then
    printf "\e\033[35m\n  Usage: $(basename ${0})   %s   %s   %s\033[0m\n\n" "eman-recipe-dir" "output-dir" "construct.yaml-dir" >&2
    exit 64
fi

set -xe
