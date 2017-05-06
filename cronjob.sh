#!/bin/bash

if [ $# -ne 1 ];then
    echo
    echo -e '\033[35m'"  Usage: $(basename ${0}) [os-label (mac, centos6, centos7, win)]"'\033[0m'
    echo
    exit 1
fi

version="2.2"

case $1 in
    'centos6') os_label="linux64.centos6"; extension="sh";  constructor_output_os_label="Linux" ;;
    'centos7') os_label="linux64.centos7"; extension="sh";  constructor_output_os_label="Linux" ;;
    'mac')     os_label="mac";             extension="sh";  constructor_output_os_label="MacOSX" ;;
    'win')     os_label="win64";           extension="exe"; constructor_output_os_label="Windows" ;;
esac

set -xe

MYDIR=$(cd $(dirname $0) && pwd -P)
EMAN_REICPE_DIR="${HOME}"/workspace/eman2-src/recipes/eman
INSTALLERS_DIR="${HOME}"/workspace/eman-installers
CONSTRUCT_YAML_DIR="${HOME}"/workspace/build-scripts/constructor

CONSTRUCTOR_OUTPUT_FILENAME="EMAN2-${version}-${constructor_output_os_label}-x86_64.${extension}"
UPLOAD_FILENAME="eman${version}.${os_label}.daily.${extension}"

timestamp=$(date "+%y-%m-%d_%H-%M-%S")

{
# Conda-build eman
source activate root

"${MYDIR}/build_and_package.sh" "${EMAN_REICPE_DIR}" \
                                "${INSTALLERS_DIR}" \
                                "${CONSTRUCT_YAML_DIR}"

# Upload installer
cp -av "${INSTALLERS_DIR}/${CONSTRUCTOR_OUTPUT_FILENAME}" "${INSTALLERS_DIR}/${UPLOAD_FILENAME}"
rsync -avzh --stats "${INSTALLERS_DIR}/${UPLOAD_FILENAME}" zope@ncmi.grid.bcm.edu:/home/zope/zope-server/extdata/reposit/ncmi/software/counter_222/software_86/

} 2>&1 | tee "${HOME}"/workspace/logs/build_${timestamp}.log
