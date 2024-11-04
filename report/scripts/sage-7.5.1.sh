#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=sage
version=7.5.1
install=/opt/tools
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}/lib
wget --quiet http://mirrors.mit.edu/sage/src/sage-7.5.1.tar.gz
tar -xvzf sage-7.5.1.tar.gz
cd sage-7.5.1
./configure --prefix=${prefix} --with-blas=openblas --with-mp=GMP
make
mkdir -p ${prefix}/bin
ln -s ${soft} ${prefix}/bin/${soft}
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## SAGE
set version 7.5.1
proc ModulesHelp { } {
puts stderr "This module enables using SAGEMATH mathematic suite"
puts stderr " "
}
module-whatis "SAGEMATH"

set prefix /opt/tools/sage-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#
/bin/cat <<"#EOF#" > ${module_path}/.modulerc
#%Module
if {![info exists nw-done]} {
module-version sage/7.5.1 7.5
module-version sage/7.5 default
set nw-done 1
}
#EOF#