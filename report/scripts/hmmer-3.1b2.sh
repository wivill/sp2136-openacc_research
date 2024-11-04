#!/bin/bash
source /opt/intel/bin/compilervars.sh intel64
source /opt/intel/impi/5.1.3.210/bin64/mpivars.sh intel64
soft=hmmer-3.1b2
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet http://eddylab.org/software/hmmer3/3.1b2/hmmer-3.1b2-linux-intel-x86_64.tar.gz
tar -xvzf hmmer-3.1b2-linux-intel-x86_64.tar.gz
cd hmmer-3.1b2-linux-intel-x86_64
./configure --prefix=/opt/libs/hmmer-3.1b2 --enable-mpi --enable-threads --enable-sse
make
make install
mkdir -p /opt/libs/modulefiles/hmmer

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hmmer/3.1b2
#%Module#####################################################################
## hmmer
set version 3.1b2
proc ModulesHelp { } {
puts stderr "This module enables using the hmmer library,"
puts stderr "for RepeatMasker tool."
puts stderr " "
}
module-whatis "hmmer library"

set prefix /opt/libs/hmmer-${version}

prepend-path CPATH ${prefix}/include/
prepend-path PATH ${prefix}/bin/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/hmmer/.modulerc
#%Module
if {![info exists hmmer-done]} {
module-version hmmer/3.1b2 3.1
module-version hmmer/3.1 default
set hmmer-done 1
}
#EOF#
