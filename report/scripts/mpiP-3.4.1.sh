#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64
soft=mpiP-3.4.1
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --prefix=/opt/libs/mpiP-3.4.1 --enable-concise-report-default --with-binutils-dir --with-libunwind
make -j20
make shared
make add_binutils_objs
make add_libunwind_objs
make install
mkdir -p /opt/libs/modulefiles/mpiP

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpiP/3.4.1
#%Module#####################################################################
## mpiP
set version 3.4.1
proc ModulesHelp { } {
puts stderr "This module enables the use of MPI Profiling."
puts stderr " "
}
module-whatis "MPI Profiling Library"
set prefix /opt/libs/mpiP-${version}
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path DOCPATH ${prefix}/share/doc
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/mpiP/.modulerc
#%Module
if {![info exists mpiP-done]} {
module-version hdf5/3.4.1 3.4
module-version hdf5/3.4 default
set mpiP-done 1
}
#EOF#