#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=isl-0.17
src=/opt/src
prefix=/opt/libs/${soft}
cd $src
mkdir -p $prefix
wget --quiet http://isl.gforge.inria.fr/isl-0.17.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --enable-shared --enable-static   --with-gmp-prefix=/opt/libs/gmp-6.1.1 --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/isl

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/isl/0.17
#%Module#################################################################
set version 0.17
proc ModulesHelp { } {
puts stderr "This module provides the ISL library, used to compile gcc."
puts stderr "It updates the environment variables \$CPATH,"
puts stderr "\$LIBRARY_PATH and \$INFOPATH accordingly."
puts stderr ""
}
module-whatis "ISL library"
set prefix /opt/libs/isl-${version}
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info

#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/isl/.modulerc
#%Module
if {![info exists isl-done]} {
#module-version isl/1.0.3 1.0
module-version isl/0.17 default
set isl-done 1
}

#EOF#
