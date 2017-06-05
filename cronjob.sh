#!/bin/bash

if [ $# -lt 1 ] || [ $# -gt 2 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0})    [os-label (mac, centos6, centos7, win)]    [branch (optional)]"'\033[0m'
    echo
    exit 1
fi

version="2.2"

case $1 in
    'centos6') os_label="linux64"; distro_label=".centos6"; ctor_out_ext="sh";  upload_ext="daily1.sh";  ;;
    'centos7') os_label="linux64"; distro_label=".centos7"; ctor_out_ext="sh";  upload_ext="daily.exe";  ;;
    'mac')     os_label="mac";     distro_label="";         ctor_out_ext="sh";  upload_ext="daily1.sh";  ;;
    'win')     os_label="win64";   distro_label="";         ctor_out_ext="exe"; upload_ext="daily1.exe"; ;;
esac

if [ $# -eq 2 ];then
    branch=$2
else
    branch="master"
fi

set -xe

MYDIR=$(cd $(dirname $0) && pwd -P)
EMAN_REPO_DIR="${HOME}"/workspace/eman2-src
EMAN_REICPE_DIR="${EMAN_REPO_DIR}"/recipes/eman
INSTALLERS_DIR="${HOME}/workspace/${1}-installers"
CONSTRUCT_YAML_DIR="${HOME}"/workspace/build-scripts/constructor

CONSTRUCTOR_OUTPUT_FILENAME="eman${version}.${os_label}.${ctor_out_ext}"
UPLOAD_FILENAME="eman${version}.${os_label}${distro_label}.${upload_ext}"

timestamp=$(date "+%y-%m-%d_%H-%M-%S")

{
# Checkout code
cd "${EMAN_REPO_DIR}"
git checkout ${branch}
git pull --rebase

mkdir -p "${INSTALLERS_DIR}"

if [ "$1" == "centos6" ];then
    bash "${MYDIR}/run_docker_build.sh" cryoem/centos6 \
                                        "${EMAN_REPO_DIR}" \
                                        "${INSTALLERS_DIR}"
else
    bash "${MYDIR}/build_and_package.sh" "${EMAN_REICPE_DIR}" \
                                         "${INSTALLERS_DIR}" \
                                         "${CONSTRUCT_YAML_DIR}"
fi

cp -av "${INSTALLERS_DIR}/${CONSTRUCTOR_OUTPUT_FILENAME}" "${INSTALLERS_DIR}/${UPLOAD_FILENAME}"

if [ "$1" != "win" ];then
    cmd="rsync -avzh --stats"
else
    cmd="scp -v"
fi

$cmd "${INSTALLERS_DIR}/${UPLOAD_FILENAME}" zope@ncmi.grid.bcm.edu:/home/zope/zope-server/extdata/reposit/ncmi/software/counter_222/software_86/

} 2>&1 | tee "${HOME}"/workspace/logs/build_${timestamp}.log
