#!/usr/bin/env bash

cat <<EOF 

INSTALLATION IS NOW COMPLETE

Important note for Linux Cluster use:
If you are using EMAN2/SPARX/SPHIRE on a cluster, the version of OpenMPI we provide may not work with your batch queueing system, meaning you would not be able to run jobs on more than one node at a time. If this is true:
- run 'utils/uninstall_openmpi.sh' to remove the OpenMPI we provided
- make sure that the correct OpenMPI for your cluster is in your path. You should be able to run 'mpicc' and get a message like 'gcc: no input files'
 (note that it is critical that OpenMPI be compiled with '--disable-dlopen', which may or may not be true on your cluster. You may need to consult a sysadmin.)
- run 'utils/install_pydusa.sh' to rebuild Pydusa using the system installed OpenMPI

EOF
