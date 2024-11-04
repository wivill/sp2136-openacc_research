#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=hdf5-1.10.0-patch1-nonparallel
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar.gz
mv hdf5-1.10.0.tar.gz ${soft}.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --prefix=$prefix --enable-cxx --enable-fortran  --enable-hl --enable-shared --enable-static --with-szlib=/opt/libs/szip-2.1 --with-mpe=/opt/tools/mpe2-2.4.9b 
make -j20
make install
mkdir -p /opt/libs/modulefiles/hdf5

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hdf5/1.10.0-patch1-nonparallel
#%Module#####################################################################
## HDF5
set version 1.10.0-patch1-nonparallel
proc ModulesHelp { } {
puts stderr "This module enables the use of a suite for managing large data sets."
puts stderr "Compiled with C++ and Fortran compatibility headers"
puts stderr " "
}
module-whatis "HDF5-nonparallel"
set prefix /opt/libs/hdf5-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/

#EOF#
