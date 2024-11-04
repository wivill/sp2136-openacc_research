#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=openmpi-2.0.1
src=/opt/src
prefix=/opt/tools/openmpi-2.0.1
cd $src
mkdir -p $prefix
wget --quiet https://www.open-mpi.org/software/ompi/v2.0/downloads/openmpi-2.0.1.tar.gz
tar -xvzf openmpi-2.0.1.tar.gz
cd $soft
./configure --with-tm=/usr/local --with-pmix --with-cuda=/opt/tools/cuda-8.0 --enable-shared --enable-static --enable-mpi-thread-multiple --prefix=$prefix
make -j20
make install
mkdir -p /opt/tools/modulefiles/openmpi

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/openmpi/2.0.1
#%Module#####################################################################
## OpenMPI Message Passing Interface package
set version 2.0.1
proc ModulesHelp { } {
puts stderr "This module enables using message passing interface libraries"
puts stderr "of the OpenMPI distribution. The environment variables \$PATH,"
puts stderr " \$LD_LIBRARY_PATH, and \$MANPATH accordingly."
puts stderr "This version includes support for MPI threads."
puts stderr " "
puts stderr "The following variables are defined for use in Makefiles:"
puts stderr "\$MPI_DIR, \$MPI_BIN, \$MPI_INC, \$MPI_LIB, \$MPI_FORTRAN_MOD_DIR"
puts stderr " "
}
module-whatis "OpenMPI message passing interface package"
set prefix /opt/tools/openmpi-${version}

prepend-path PATH ${prefix}/bin
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
prepend-path CPATH ${prefix}/include

setenv MPI_BIN ${prefix}/bin
setenv MPI_SYSCONFIG ${prefix}/etc
setenv MPI_FORTRAN_MOD_DIR ${prefix}/lib
setenv MPI_INC ${prefix}/include
setenv MPI_LIB ${prefix}/lib   
setenv MPI_MAN ${prefix}/share/man
setenv MPI_HOME ${prefix}
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/openmpi/.modulerc
#%Module
if {![info exists openmpi-done]} {
module-version openmpi/2.0.1 2.0
module-version openmpi/2.0 default
set openmpi-done 1
}
#EOF#