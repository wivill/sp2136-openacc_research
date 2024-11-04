#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=boost
version=1_56_0-icc
install=/opt/libs
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}
wget --quiet http://downloads.sourceforge.net/project/boost/boost/1.56.0/boost_1_56_0.tar.bz2
tar -xvjf boost_1_56_0.tar.bz2
cd boost_1_56_0
CC=icc CXX=icpc ./bootstrap.sh --prefix=/opt/libs/boost_1_56_0
./b2 install
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## Boost
set version 1_56_0-icc
proc ModulesHelp { } {
puts stderr "This module enables Boost Library"
puts stderr " "
}
module-whatis "Boost Library"

set prefix /opt/libs/boost-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#