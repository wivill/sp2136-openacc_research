#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=sparsehash
version=git-icc
install=/opt/tools
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}
git clone https://github.com/sparsehash/sparsehash.git
cd $soft
CC=icc CXX=icpc ./configure --prefix=$prefix
make
make install
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## sparsehash
set version git-icc
proc ModulesHelp { } {
puts stderr "This module enables Sparsehash tools"
puts stderr " "
}
module-whatis "Sparsehash Tools"

set prefix /opt/libs/sparsehash-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#