#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=genemark_suite_linux_64.tar.gz
src=/opt/src
prefix=/opt/tools/$soft
cd $src
mkdir -p $prefix
wget --quiet http://topaz.gatech.edu/GeneMark/tmp/GMtool_ZtiXL/genemark_suite_linux_64.tar.gz 
tar -xvzf $soft.tar.gz
cd $soft
cp -rf gm_key /home/*/.gm_key
cp ./* ${prefix}
mkdir -p /opt/tools/modulefiles/GeneMarkSuite

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/GeneMarkSuite/4.30.0
#%Module#####################################################################
## netcdf-
set version 4.30.0
proc ModulesHelp { } {
puts stderr "This module enables the use of GeneMark Suite software"
puts stderr " "
}
module-whatis "GeneMarkSuite"
set prefix /opt/tools/genemark_suite_linux_64
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}:${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/lib
prepend-path LIBRARY_PATH ${prefix}/lib
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/GeneMarkSuite/.modulerc
#%Module
if {![info exists gms-done]} {
module-version gms/4.30.0 4.30
module-version gms/4.30 default
set gms-done 1
}
#EOF#