#!/bin/bash
. /opt/intel/bin/compilervars.sh intel64
soft=libgtextutils-0.7
src=/opt/src
prefix=/opt/libs/$soft
cd $src
mkdir -p $prefix
wget --quiet https://github.com/agordon/libgtextutils/releases/download/0.7/libgtextutils-0.7.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --prefix=$prefix --enable-shared --enable-static --enable-wall 
make -j4
make install
mkdir -p /opt/libs/modulefiles/libgtextutils

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/libgtextutils/0.7
#%Module#####################################################################
## libgtetutils
set version 0.7
## 
set version 0.7
proc ModulesHelp { } {
puts stderr "This module enables using the libgtextutils environment,"
puts stderr ". The environment variables \$PATH, \$CPATH, \$LIBRARY_PATH,"
puts stderr " \$LD_LIBRARY_PATH, and \$MANPATH are set accordingly."
puts stderr " "
}
module-whatis "libgtexutil"

set prefix /opt/libs/libgtextutils-${version}

prepend-path CPATH ${prefix}/include/
prepend-path LIBRARY_PATH ${prefix}/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib/
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/libgtextutils/.modulerc
#%Module
if {![info exists lib-done]} {
module-version libgtextutils/0.7 0.7
module-version libgtextutils/0.7 default
set lib-done 1
}
#EOF#