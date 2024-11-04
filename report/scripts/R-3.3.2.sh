#!/bin/bash
. /opt/intel/bin/compilervars.sh intel64
soft=R-3.3.2
src=/opt/src
prefix=/opt/compilers/$soft
cd $src
mkdir -p $prefix
wget --quiet https://cran.cnr.berkeley.edu/src/base/R-3/R-3.3.2.tar.gz
tar -xvzf ${soft}.tar.gz
cd $soft
./configure --prefix=$prefix --enable-R-profiling --enable-memory-profiling --enable-R-shlib --enable-R-static-lib --enable-BLAS-shlib --enable-static --enable-shared --enable-long-double --with-blas=/home/soft/libs/openblas-0.2.14 --with-lapack=/home/soft/libs/lapack-3.5.0 --with-cairo=/home/soft/libs/cairo-1.6.4 --with-libpng=/home/soft/libs/libpng-1.2.53 --with-recommended-packages
make -j4
make install
mkdir -p /opt/compilers/modulefiles/R

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/R/3.3.2
#%Module#####################################################################
## R
set version 3.3.2
## R software environment for statistical computing and graphics package
set version 3.3.2
proc ModulesHelp { } {
puts stderr "This module enables using the R environment,"
puts stderr "which allows data handling and calculations for statistical analysis"
puts stderr ". The environment variables \$PATH, \$CPATH, \$LIBRARY_PATH,"
puts stderr " \$LD_LIBRARY_PATH, and \$MANPATH are set accordingly."
puts stderr " "
}
module-whatis "R software environment for statistical computing and graphics"

set prefix /opt/compilers/R-${version}

setenv R_HOME ${prefix}/lib64/R

prepend-path CPATH ${prefix}/lib64/R/include/
prepend-path PATH ${prefix}/lib64/R/bin/
prepend-path LIBRARY_PATH ${prefix}/lib64/R/lib/
prepend-path LIBRARY_PATH ${prefix}/lib64/R/libs/
prepend-path LD_LIBRARY_PATH ${prefix}/lib64/R/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib64/R/libs/
prepend-path MANPATH ${prefix}/share/man/

#R packages enviroment variables

#RInside
prepend-path CPATH ${prefix}/lib64/R/library/RInside/include/
prepend-path LIBRARY_PATH ${prefix}/lib64/R/library/RInside/lib/
prepend-path LIBRARY_PATH ${prefix}/lib64/R/library/RInside/libs/
prepend-path LD_LIBRARY_PATH ${prefix}/lib64/R/library/RInside/lib/
prepend-path LD_LIBRARY_PATH ${prefix}/lib64/R/library/RInside/libs/

#RCpp
prepend-path CPATH ${prefix}/lib64/R/library/Rcpp/include/
prepend-path LIBRARY_PATH ${prefix}/lib64/R/library/Rcpp/libs/
prepend-path LD_LIBRARY_PATH ${prefix}/lib64/R/library/Rcpp/libs/

#EOF#

/bin/cat <<"#EOF#" > /opt/compilers/modulefiles/R/.modulerc
#%Module
if {![info exists R-done]} {
module-version R/3.3.2 3.3
module-version R/3.3 default
set R-done 1
}

#EOF#