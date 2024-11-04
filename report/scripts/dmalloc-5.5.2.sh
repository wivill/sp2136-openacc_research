#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=dmalloc-5.5.2
src=/opt/src
prefix=/opt/libs/${soft}
cd $src
mkdir -p $prefix
wget --quiet http://dmalloc.com/releases/dmalloc-5.5.2.tgz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --prefix=$prefix --enable-cxx --enable-fortran --enable-threads
make -j20
make cxx
make threadscxx
make install
make installdocs
mkdir -p /opt/libs/modulefiles/dmalloc

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/dmalloc/5.5.2
#%Module#################################################################
set version 5.5.2
proc ModulesHelp { } {
puts stderr "This module provides the dmalloc library."
puts stderr ""
}
module-whatis "dmalloc library"
set prefix /opt/libs/dmalloc-${version}
prepend-path DOCPATH ${prefix}/share/doc
prepend-path CPATH ${prefix}/include
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man
prepend-path INFOPATH ${prefix}/share/info


#EOF#

/bin/cat <<"#EOF#" > /opt/libs/modulefiles/dmalloc/.modulerc
#%Module
if {![info exists dmalloc-done]} {
module-version dmalloc/5.5.2 5.5
module-version dmalloc/5.5 default
set dmalloc-done 1
}

#EOF#