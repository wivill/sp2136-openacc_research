#!/bin/bash

source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64

soft=cblas
version=3.7.0
install=/opt/libs
src=/opt/src
module_path=${install}/modulefiles/${soft}
prefix=${install}/${soft}-${version}
cd $src
mkdir -p ${prefix}/lib
wget --quiet http://www.netlib.org/blas/blast-forum/cblas.tgz
tar -xvzf cblas.tgz
cd CBLAS
ln -s Makefile.LINUX Makefile.in
echo "\nCBDIR = /opt/src/CBLAS\n" >> Makefile.in
sed -i -e 's/BLLIB/#/g' Makefile.in
echo "\nBLLIB = /opt/libs/blas-3.7.0/lib/libblas.a\n" >> Makefile.in
make all
cd src
ar rv libcblas.a *.o
cp libcblas.a ${prefix}/lib
cd ../testing
ar rv libcblas_testing.a *.o
cp libcblas_testing.a {prefix}/lib
mkdir -p ${module_path}

/bin/cat <<"#EOF#" > ${module_path}/${version}
#%Module#####################################################################
## cblas
set version 3.7.0
proc ModulesHelp { } {
puts stderr "This module enables CBLAS"
puts stderr " "
}
module-whatis "CBLAS"

set prefix /opt/libs/cblas-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > ${module_path}/.modulerc
#%Module
if {![info exists nw-done]} {
module-version cblas/3.7.0 3.7
module-version cblas/3.7 default
set nw-done 1
}
#EOF#
