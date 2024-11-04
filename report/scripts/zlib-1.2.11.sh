#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=zlib-1.2.11
src=/opt/src
prefix=/opt/libs/${soft}
cd $src
mkdir -p $prefix
wget --quiet https://www.zlib.net/zlib-1.2.11.tar.gz
tar -xvzf ${soft}.tar.gz
cd ${soft}
./configure --prefix=$prefix
make -j4
make install
mkdir -p /opt/libs/modulefiles/zlib

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/zlib/1.2.11
#%Module#####################################################################
## zlib
set version 1.2.11
proc ModulesHelp { } {
puts stderr "This module enables the use of lossless compression of scientific data "
puts stderr " "
}
module-whatis "zlib with gcc"
set prefix /opt/libs/zlib-${version}
prepend-path PATH ${prefix}/bin
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#
