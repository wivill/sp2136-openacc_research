#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=gcc-5.4.0
src=/opt/src
prefix=/opt/compilers/gcc-5.4.0
cd $src
mkdir -p $prefix
wget --quiet http://mirrors-usa.go-parts.com/gcc/releases/gcc-5.4.0/gcc-5.4.0.tar.gz
tar -xvzf gcc-5.4.0.tar.gz
cd $soft
export LD_LIBRARY_PATH=/opt/libs/isl-0.17/lib:/opt/libs/gmp-6.1.1/lib:/opt/libs/mpc-1.0.3/lib:/opt/libs/mpfr-3.1.5/lib:$LD_LIBRARY_PATH
./configure --prefix=$prefix --enable-shared --disable-multilib --with-isl=/opt/libs/isl-0.17 --with-gmp=/opt/libs/gmp-6.1.1 --with-mpfr=/opt/libs/mpfr-3.1.5 --with-mpc=/opt/libs/mpc-1.0.3  --with-tune=generic --enable-languages=c,c++,fortran --enable-threads=posix --enable-__cxa_atexit --with-system-zlib --enable-plugin --enable-initfini-array --with-arch_32=x86-64 --enable-bootstrap --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id
make -j240
make install
mkdir -p /opt/compilers/modulefiles/gcc

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/gcc/5.4.0
#%Module#################################################################
set version 5.4.0
proc ModulesHelp { } {
puts stderr "This module provides a version ${version} of the GNU C,"
puts stderr "C++ and Fortran compilers as an alternative to the operating"
puts stderr "system default version.\n"
puts stderr ""
}
module-whatis "Alternate GNU C/C++/Fortran Compilers"
set prefix /opt/compilers/gcc-${version}
prepend-path CPATH ${prefix}/include
prepend-path INCLUDE ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info
prepend-path LIBRARY_PATH ${prefix}/lib:${prefix}/lib64
prepend-path LD_LIBRARY_PATH ${prefix}/lib64:${prefix}/lib
#EOF#
