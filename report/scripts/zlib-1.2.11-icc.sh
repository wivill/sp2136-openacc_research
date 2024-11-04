#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=zlib-1.2.11
src=/opt/src
prefix=/opt/libs/${soft}-icc
cd $src
mkdir -p $prefix
wget --quiet https://www.zlib.net/zlib-1.2.11.tar.gz
tar -xvzf ${soft}.tar.gz
mv $soft ${soft}-icc
cd ${soft}-icc
FC=/opt/intel/bin/ifort CC=/opt/intel/bin/icc CXX=/opt/intel/bin/icpc ./configure --prefix=$prefix
make -j4
make install
mkdir -p /opt/libs/modulefiles/zlib

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/zlib/1.2.11-icc
#%Module#####################################################################
## zlib
set version 1.2.11-icc
proc ModulesHelp { } {
puts stderr "This module enables the use of lossless compression of scientific data "
puts stderr " "
}
module-whatis "zlib with Intel compiler"
set prefix /opt/libs/zlib-${version}
prepend-path PATH ${prefix}/bin
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#