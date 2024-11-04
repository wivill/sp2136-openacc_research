#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=abyss
version=git-icc
install=/opt/tools
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}
git clone https://github.com/bcgsc/abyss.git
cd $soft
./autogen.sh
CC=icc ./configure --enable-maxk=320 --enable-mpich --with-mpi=/opt/tools/mpich-3.2/bin --prefix=/opt/tools/abyss-git-icc --with-boost=/opt/libs/boost_1_56_0-icc --with-sparsehash=/opt/tools/sparsehash-git-icc
make
make install
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## ABySS
set version git-icc
proc ModulesHelp { } {
puts stderr "This module enables ABySS sequencing tools"
puts stderr " "
}
module-whatis "ABySS Tools"

set prefix /opt/tools/abyss-${version}

prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
#EOF#