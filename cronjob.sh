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

MYDIR=$(cd $(dirname $0) && pwd -P)
HOME_DIR='/c/Users/EMAN'
EMAN_REPO_DIR="${HOME_DIR}"/workspace/eman2-cron
EMAN_REICPE_DIR="${EMAN_REPO_DIR}"/recipes/eman
INSTALLERS_DIR="${HOME_DIR}/workspace/${1}-installers"
CONSTRUCT_YAML_DIR="${HOME_DIR}"/workspace/build-scripts-cron/constructor

CONSTRUCTOR_OUTPUT_FILENAME="eman2.${os_label}.${ctor_out_ext}"

# Checkout code
cd "${EMAN_REPO_DIR}"
git fetch --prune
git checkout v2.21a || git checkout origin/v2.21a

mkdir -p "${INSTALLERS_DIR}"

if [ "$1" == "centos6" ];then
    bash "${MYDIR}/run_docker_build.sh" cryoem/centos6:working \
                                        "${EMAN_REPO_DIR}" \
                                        "${INSTALLERS_DIR}"
else
    bash "${MYDIR}/build_and_package.sh" "${EMAN_REICPE_DIR}" \
                                         "${INSTALLERS_DIR}" \
                                         "${CONSTRUCT_YAML_DIR}"

    if [ "$1" != "win" ];then
        bash "${EMAN_REPO_DIR}"/tests/test_binary_installation.sh "${INSTALLERS_DIR}" "${CONSTRUCTOR_OUTPUT_FILENAME}"
    else
        cmd "/C ${WORKSPACE//\//\\}\\tests\\test_binary_installation.bat c:\\Users\\EMAN\\workspace\\win-installers eman2.win.exe "
    fi
fi

git checkout -f master
