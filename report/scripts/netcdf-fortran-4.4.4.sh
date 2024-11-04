#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=netcdf-fortran-4.4.4
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.4.tar.gz
tar -xvzf $soft.tar.gz
cd $soft
./configure --prefix=$prefix --enable-static --enable-shared 
make -j20
make install
mkdir -p /opt/libs/modulefiles/netcdf-fortran

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/netcdf-fortran/4.4.4
#%Module#####################################################################
## netcdf-fortran
set version 4.4.4
proc ModulesHelp { } {
puts stderr "This module enables the use of data formats supporting the "
puts stderr "creation, access and sharing of array oriented scientific "
puts stderr "data."
puts stderr " "
}
module-whatis "Network Common Data Form with fortran support"
set prefix /opt/tools/netcdf-fortran-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/netcdf-fortran/.modulerc
#%Module
if {![info exists netcdf-fortran-done]} {
module-version netcdf-fortran/4.4.4 4.4
module-version netcdf-fortran/4.4 default
set netcdf-fortran-done 1
}
#EOF#