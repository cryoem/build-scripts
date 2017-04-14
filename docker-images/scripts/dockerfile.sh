#!/usr/bin/env bash

mydir=$(cd $(dirname $0); pwd -P)

bash "${mydir}/yum.sh"
bash "${mydir}/conda_environment.sh"
