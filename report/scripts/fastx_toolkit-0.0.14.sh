#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=fastx_toolkit-0.0.14
src=/opt/src
prefix=/opt/tools/$soft
cd $src
mkdir -p $prefix
wget --quiet https://github.com/agordon/fastx_toolkit/releases/download/0.0.14/fastx_toolkit-0.0.14.tar.bz2
tar -xvjf $soft.tar.bz2
cd $soft
export PKG_CONFIG_PATH=/opt/libs/libgtextutils-0.7/lib/pkgconfig
./configure --prefix=$prefix --enable-static --enable-shared 
make -j20
make install
mkdir -p /opt/tools/modulefiles/fastx_toolkit

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/fastx_toolkit/0.0.14
#%Module#####################################################################
## fastx-toolkit
set version 0.0.14
proc ModulesHelp { } {
puts stderr "This module enables the use of command line tools for "
puts stderr " Short-Reads FASTA/FASTQ files preprocessing"
puts stderr " "
}
module-whatis "FASTX-Toolkit command line tools"
set prefix /opt/tools/fastx_toolkit-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/fastx_toolkit/.modulerc
#%Module
if {![info exists fastx-done]} {
module-version fastx_toolkit/0.0.14 0.14
module-version fastx_toolkit/0.14 default
set fastx-done 1
}
#EOF#
