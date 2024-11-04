#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=mpc-1.0.3
src=/opt/src
prefix=/opt/libs/${soft}
cd $src
mkdir -p $prefix
wget --quiet ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --enable-shared --enable-static --with-gmp=/opt/libs/gmp-6.1.1 --with-mpfr=/opt/libs/mpfr-3.1.5 --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/mpc

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpc/1.0.3
#%Module#################################################################
set version 1.0.3
proc ModulesHelp { } {
puts stderr "This module provides the MPC library, used to compile gcc."
puts stderr "It updates the environment variables \$CPATH,"
puts stderr "\$LIBRARY_PATH and \$INFOPATH accordingly."
puts stderr ""
}
module-whatis "MPC library"
set prefix /opt/libs/mpc-${version}
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpc/.modulerc
#%Module
if {![info exists mpc-done]} {
module-version mpc/1.0.3 1.0
module-version mpc/1.0 default
set mpc-done 1
}
#EOF#