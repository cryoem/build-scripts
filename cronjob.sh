#!/bin/bash

function print_usage(){
    printf "\e\033[35m\n  Usage: $(basename ${0}) %s %s\n\n\033[0m" "{mac|centos6|centos7|win}" "[branch-to-checkout]" >&2
    exit 64
}


version="2.2"

case $# in
    1|2)
        case $1 in
            'centos6') os_label="linux64"; distro_label=".${1}"; ctor_out_ext="sh";  upload_ext="daily1.sh";  ;;
            'centos7') os_label="linux64"; distro_label=".${1}"; ctor_out_ext="sh";  upload_ext="daily.exe";  ;;
            'mac')     os_label="mac";     distro_label="";      ctor_out_ext="sh";  upload_ext="daily1.sh";  ;;
            'win')     os_label="win64";   distro_label="";      ctor_out_ext="exe"; upload_ext="daily1.exe"; ;;
            *)         print_usage; ;;
        esac

        branch=${2:-"master"}
        ;;

    *) print_usage
       ;;
esac

set -xe

MYDIR=$(cd $(dirname $0) && pwd -P)
EMAN_REPO_DIR="${HOME}"/workspace/eman2-cron
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

if [ ${SKIP_UPLOAD:-1} -ne 1 ];then
if [ "$1" != "win" ];then
    cmd="rsync -avzh --stats"
else
    cmd="scp -v"
fi

$cmd "${INSTALLERS_DIR}/${UPLOAD_FILENAME}" zope@ncmi.grid.bcm.edu:/home/zope/zope-server/extdata/reposit/ncmi/software/counter_222/software_86/
fi

} 2>&1 | tee "${HOME}"/workspace/logs/build_${timestamp}.log
