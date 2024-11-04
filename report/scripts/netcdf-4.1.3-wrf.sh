#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
soft=netcdf-4.1.3
src=/opt/src
prefix=/opt/libs/${soft}-icc-wrf
cd $src
mkdir -p $prefix
tar -xvzf ${soft}.tar.gz
cd $soft
FC=/opt/intel/bin/ifort CC=/opt/intel/bin/icc CXX=/opt/intel/bin/icpc ./configure --disable-shared --prefix=$prefix --enable-fortran --disable-netcdf-4
make -j4
make install
mkdir -p /opt/libs/modulefiles/netcdf

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/netcdf/4.1.3-icc-wrf
#%Module#####################################################################
## netCDF 
set version 4.1.3-icc-wrf
proc ModulesHelp { } {
puts stderr "This module enables the use of data formats supporting the "
puts stderr "creation, access and sharing of array oriented scientific "
puts stderr "data."
puts stderr " "
puts stderr "Added --enable-fortran --disable-netcdf-4"
puts stderr "Compiled with icc"
}
module-whatis "Network Common Data Form"
set prefix /opt/libs/netcdf-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
#EOF#