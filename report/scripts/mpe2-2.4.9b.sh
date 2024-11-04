#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=mpe2-2.4.9b
src=/opt/src
prefix=/opt/tools/${soft}
cd $src
mkdir -p $prefix
wget --quiet ftp://ftp.mcs.anl.gov/pub/mpi/mpe/mpe2.tar.gz
tar -xvzf mpe2.tar.gz
cd $soft
F77=/opt/intel/bin/ifort MPI_CC=/opt/intel/impi/5.1.3.210/bin64/mpicc MPI_F77=/opt/intel/impi/5.1.3.210/bin64/mpiifort MPI_INC=/opt/intel/impi/5.1.3.210/include64   ./configure --prefix=$prefix --enable-PIC --enable-mpich
make -j20
make install
mkdir -p /opt/tools/modulefiles/mpe2

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/mpe2/2.4.9b
#%Module#################################################################
set version 2.4.9b
proc ModulesHelp { } {
puts stderr "This module provides the MPI Parallel Environment library."
puts stderr ""
}
module-whatis "MPI Parallel Environment library"
set prefix /opt/libs/mpe2-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin:${prefix}/sbin
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/mpe2/.modulerc
#%Module
if {![info exists mpe2-done]} {
module-version mpe2/2.4.9b 2.4
module-version mpe2/2.4 default
set mpe2-done 1
}
#EOF#