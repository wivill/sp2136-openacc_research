#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=blas
version=3.7.0
install=/opt/libs
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}/lib
wget --quiet http://www.netlib.org/blas/blas-3.7.0.tgz
tar -xvzf blas-3.7.0.tgz
cd BLAS-3.7.0
make all
ar rv libblas.a *.o
cp libblas.a ${prefix}/lib

mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## BLAS
set version 3.7.0
proc ModulesHelp { } {
puts stderr "This module enables using BLAS library"
puts stderr " "
}
module-whatis "BLAS Library"

set prefix /opt/libs/blas-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#
/bin/cat <<"#EOF#" > ${module_path}/.modulerc
#%Module
if {![info exists nw-done]} {
module-version blas/3.7.0 3.7
module-version blas/3.7 default
set nw-done 1
}
#EOF#
