#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=Python-3.5.2
src=/opt/src
prefix=/opt/compilers/python-3.5.2
cd $src
mkdir -p $prefix
wget --quiet https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
tar -xvzf Python-3.5.2.tgz
cd $soft
./configure --with-icc --enable-shared --enable-profiling --disable-ipv6 --prefix=$prefix
make -j20
make install
mkdir -p /opt/compilers/modulefiles/python

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/python/3.5.2
#%Module#######################################################
set version 3.5.2
proc ModulesHelp { } {
puts stderr "This module provides Python version 3.5.2"
puts stderr "It updates the environment variables \$PATH,"
puts stderr "\$LD_LIBRARY_PATH, and \$CPATH"
puts stderr ""
}
module-whatis "Python 3.5.2"
set prefix /opt/compilers/python-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path PYTHONPATH ${prefix}/lib/python3.4/site-packages
#EOF#

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/python/.modulerc

#%Module
if {![info exists python3-done]} {
module-version python/3.5.2 3.5
module-version python/3.5 default
set python3-done 1
}
#EOF#