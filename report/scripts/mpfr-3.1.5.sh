#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=mpfr-3.1.5
src=/opt/src
prefix=/opt/libs/${soft}
cd $src
mkdir -p $prefix
wget --quiet http://www.mpfr.org/mpfr-current/mpfr-3.1.5.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --enable-shared --enable-static  --enable-warnings --with-gmp=/opt/libs/gmp-6.1.1 --enable-assert --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/mpfr

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpfr/3.1.5
#%Module#################################################################
set version 3.1.5
proc ModulesHelp { } {
puts stderr "This module provides the MPFR-3 library, used to compile mpc."
puts stderr "It updates the environment variables \$CPATH,"
puts stderr "\$LIBRARY_PATH and \$INFOPATH accordingly."
puts stderr ""
}
module-whatis "The MPFR library is a C library for multiple-precision floating-point computations with correct rounding"
set prefix /opt/libs/mpfr-${version}
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path INFOPATH ${prefix}/share/info
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpfr/.modulerc
#%Module
if {![info exists mpfr-done]} {
module-version mpfr/3.1.5 3.1
module-version mpfr/3.1 default
set mpfr-done 1
}
#EOF#