#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=hdf5-1.10.0-patch1
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
#CC=/opt/tools/openmpi-2.0.1/bin/mpicc CPPFLAGS=/opt/tools/openmpi-2.0.1/include/mpi.h ./configure --enable-shared --enable-static --enable-parallel --enable-fortran --enable-cxx --enable-hl --enable-unsupported --prefix=$prefix
CC=/opt/intel/impi/5.1.3.210/bin64/mpicc ./configure --prefix=$prefix  --enable-hl --enable-shared --enable-static --enable-parallel --with-szlib=/opt/libs/szip-2.1 --with-mpe=/opt/tools/mpe2-2.4.9b 
make -j20
make install
mkdir -p /opt/libs/modulefiles/hdf5

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hdf5/1.10.0-patch1
#%Module#####################################################################
## HDF5
set version 1.10.0-patch1
proc ModulesHelp { } {
puts stderr "This module enables the use of a suite for managing large data sets."
puts stderr " "
}
module-whatis "HDF5"
set prefix /opt/libs/hdf5-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/

#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hdf5/.modulerc
#%Module
if {![info exists hdf5-done]} {
module-version hdf5/1.10.0-patch1 1.10
module-version hdf5/1.10 default
set hdf5-done 1
}

#EOF#
