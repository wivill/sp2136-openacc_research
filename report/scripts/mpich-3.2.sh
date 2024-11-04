#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=mpich-3.2
src=/opt/src
prefix=/opt/tools/mpich-3.2
cd $src
mkdir -p $prefix
wget --quiet http://www.mpich.org/static/downloads/3.2/mpich-3.2.tar.gz
tar -xvzf mpich-3.2.tar.gz
cd $soft
./configure --with-pm=hydra --with-pmi=simple --enable-shared --enable-static --enable-threads=multiple --prefix=$prefix
make -j20
make install
mkdir -p /opt/tools/modulefiles/mpich

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/mpich/3.2.1
#%Module#####################################################################
## MPICH Message Passing Interface package
set version 3.2
proc ModulesHelp { } {
puts stderr "This module enables using message passing interface libraries"
puts stderr "of the MPICH distribution. The environment variables \$PATH,"
puts stderr " \$LD_LIBRARY_PATH, and \$MANPATH accordingly."
puts stderr "This version includes support for MPI threads."
puts stderr " "
puts stderr "The following variables are defined for use in Makefiles:"
puts stderr "\$MPI_DIR, \$MPI_BIN, \$MPI_INC, \$MPI_LIB, \$MPI_FORTRAN_MOD_DIR"
puts stderr " "
}
module-whatis "MPICH message passing interface package"
set prefix /opt/tools/mpich-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
setenv MPI_BIN ${prefix}/bin
setenv MPI_SYSCONFIG ${prefix}/etc
setenv MPI_FORTRAN_MOD_DIR ${prefix}/lib
setenv MPI_INC ${prefix}/include
setenv MPI_LIB ${prefix}/lib   
setenv MPI_MAN ${prefix}/share/man
setenv MPI_HOME ${prefix}
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/mpich/.modulerc
#%Module
if {![info exists mpich-done]} {
module-version mpich/3.2.1 3.2
module-version mpich/3.2 default
set mpich-done 1
}
#EOF#