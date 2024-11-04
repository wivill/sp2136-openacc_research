#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=velvet
src=/opt/src
prefix=/opt/tools/${soft}-1.2.10
cd $src
mkdir -p $prefix
git clone git://github.com/dzerbino/velvet.git
cd $soft
make 'OPENMP=1'
make color
mkdir -p /opt/tools/modulefiles/velvet
exes=/opt/src/velvet

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/velvet/1.2.10
#%Module#####################################################################
## velvet 
set version 1.2.10
proc ModulesHelp { } {
puts stderr "This module enables the use of Velvet sequence assembler"
puts stderr "for very short reads."
puts stderr "The compilation options used are:"
puts stderr "make"
puts stderr "make color"
puts stderr "make 'OPENMP=1' "

}
module-whatis "Velvet sequence assembler"
set prefix /opt/src/velvet
prepend-path PATH ${prefix}
#EOF#