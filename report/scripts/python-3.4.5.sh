#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=Python-3.4.5
src=/opt/src
prefix=/opt/compilers/python-3.4.5
cd $src
mkdir -p $prefix
wget --quiet https://www.python.org/ftp/python/3.4.5/Python-3.4.5.tgz
tar -xvzf Python-3.4.5.tgz
cd $soft
./configure --with-icc --enable-shared --enable-profiling --disable-ipv6 --prefix=$prefix
make -j20
make install
mkdir -p /opt/compilers/modulefiles/python

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/python/3.4.5
#%Module#######################################################
set version 3.4.5
proc ModulesHelp { } {
puts stderr "This module provides Python version 3.4.5"
puts stderr "It updates the environment variables \$PATH,"
puts stderr "\$LD_LIBRARY_PATH, and \$CPATH"
puts stderr ""
}
module-whatis "Python 3.4.5"
set prefix /opt/compilers/python-${version}
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path PYTHONPATH ${prefix}/lib/python3.4/site-packages
#EOF#