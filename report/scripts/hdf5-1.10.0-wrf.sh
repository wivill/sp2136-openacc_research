#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
soft=hdf5-1.10.0-wrf-chem
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar.gz
mv hdf5-1.10.0.tar.gz ${soft}.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
FC=/opt/intel/bin/ifort CC=/opt/intel/bin/icc CXX=/opt/intel/bin/icpc ./configure --prefix=/opt/libs/hdf5-1.10.0-wrf-chem --disable-shared --enable-fortran --with-szlib=/opt/libs/szip-2.1
make -j20
make check
make install
make check-install
mkdir -p /opt/libs/modulefiles/hdf5

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hdf5/1.10.0-wrf-chem
#%Module#####################################################################
## HDF5
set version 1.10.0-wrf-chem
proc ModulesHelp { } {
puts stderr "This module enables the use of a suite for managing large data sets."
puts stderr "Compiled with icc, ifort and icpc"
puts stderr "Flags: FC=ifort CC=icc CXX=icpc "
}
module-whatis "HDF5-wrf"
set prefix /opt/libs/hdf5-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/

#EOF#