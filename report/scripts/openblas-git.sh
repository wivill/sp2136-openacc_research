#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=openblas
version=git
install=/opt/libs
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}/lib
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make
make install PREFIX=${prefix}
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## OpenBLAS
set version git
proc ModulesHelp { } {
puts stderr "This module enables using OpenBLAS library"
puts stderr " "
}
module-whatis "BLAS Library"

set prefix /opt/libs/openblas-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#
/bin/cat <<"#EOF#" > ${module_path}/.modulerc
#%Module
if {![info exists nw-done]} {
module-version openblas/git default
set nw-done 1
}
#EOF#
