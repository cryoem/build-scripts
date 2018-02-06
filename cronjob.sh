#!/bin/bash

function print_usage(){
    printf "\e\033[35m\n  Usage: $(basename ${0}) %s %s\n\n\033[0m" "{mac|centos6|centos7|win}" "[branch-to-checkout]" >&2
    exit 64
}


case $# in
    1|2)
        case $1 in
            'centos6') os_label="linux"; ctor_out_ext="sh";  ;;
            'centos7') os_label="linux"; ctor_out_ext="sh";  ;;
            'mac')     os_label="mac";   ctor_out_ext="sh";  ;;
            'win')     os_label="win";   ctor_out_ext="exe"; ;;
            *)         print_usage; ;;
        esac

        distro_label=${1}
        branch=${2:-"master"}
        ;;

    *) print_usage
       ;;
esac

set -xe

EMAN_REPO_DIR="${HOME_DIR}"/workspace/eman2-cron
INSTALLERS_DIR="${HOME_DIR}/workspace/${1}-installers"

# Checkout code
cd "${EMAN_REPO_DIR}"
git fetch --prune
git checkout ${branch} || git checkout -t origin/${branch}
git pull --rebase

mkdir -p "${INSTALLERS_DIR}"
