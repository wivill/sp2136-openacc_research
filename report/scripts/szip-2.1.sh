#!/bin/bash

#. /opt/intel/bin/compilervars.sh intel64
soft=szip-2.1
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet https://support.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --enable-shared --enable-static --enable-encoding --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/szip

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/netcdf/4.4.1
#%Module#####################################################################
## szip
set version 2.1
proc ModulesHelp { } {
puts stderr "This module enables the use of lossless compression of scientific data "
puts stderr " "
}
module-whatis "szip compression library"
set prefix /opt/libs/szip-${version}
prepend-path PATH ${prefix}/bin
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/szip/.modulerc
#%Module
if {![info exists szip-done]} {
module-version szip/2.1 default
set szip-done 1
}
#EOF#