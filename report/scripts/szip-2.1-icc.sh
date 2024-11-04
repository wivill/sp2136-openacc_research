#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
soft=szip-2.1
src=/opt/src
prefix=/opt/libs/${soft}-icc
cd $src
mkdir -p $prefix
wget --quiet https://support.hdfgroup.org/ftp/lib-external/szip/2.1/src/szip-2.1.tar.gz
tar -xvzf ${soft}.tar.gz
mv $soft ${soft}-icc
cd ${soft}-icc
FC=/opt/intel/bin/ifort CC=/opt/intel/bin/icc CXX=/opt/intel/bin/icpc ./configure --enable-shared --enable-static --enable-encoding --prefix=$prefix
make -j20
make install
mkdir -p /opt/libs/modulefiles/szip

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/szip/2.1-icc
#%Module#####################################################################
## szip
set version 2.1-icc
proc ModulesHelp { } {
puts stderr "This module enables the use of lossless compression of scientific data"
puts stderr "Uses Intel compiler "
}
module-whatis "szip compression library with Intel compiler"
set prefix /opt/libs/szip-${version}
prepend-path PATH ${prefix}/bin
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#