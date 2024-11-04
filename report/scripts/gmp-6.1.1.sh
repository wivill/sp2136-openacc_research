#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=gmp-6.1.1
src=/opt/src
prefix=/opt/libs/gmp-6.1.1
cd $src
mkdir -p $prefix
wget --quiet https://gmplib.org/download/gmp/gmp-6.1.1.tar.xz
tar -xvf gmp-6.1.1.tar.xz
cd $soft
./configure --enable-cxx --enable-assert --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/gmp

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/gmp/6.1.1
#%Module#################################################################
set version 6.1.1
proc ModulesHelp { } {
puts stderr "This module provides a version ${version} of the GMP"
puts stderr "multiple precision arithmetic library."
puts stderr "\n"
puts stderr ""
}
module-whatis "GMP Library"
set prefix /opt/libs/gmp-${version}
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info

#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/gmp/.modulerc
#%Module
if {![info exists gmp-done]} {
module-version gmp/6.1.1 6.1
module-version gmp/6.1 default
set gmp-done 1
}

#EOF#
