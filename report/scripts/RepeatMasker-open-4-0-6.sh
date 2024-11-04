#!/bin/bash

. /opt/intel/bin/compilervars.sh intel64
soft=RepeatMasker-open-4-0-6
src=/opt/src
prefix=/opt/tools/RepeatMasker
cd $src
mkdir -p $prefix
wget --quiet http://www.repeatmasker.org/RepeatMasker-open-4-0-6.tar.gz 
tar -xvzf $soft.tar.gz
cd RepeatMasker
cp ./* ${prefix}
cd $prefix
wget --quiet --user wivill --password 0ewjf4 http://www.girinst.org/server/RepBase/protected/repeatmaskerlibraries/RepBaseRepeatMaskerEdition-20170127.tar.gz
wget --quiet --user wivill --password 0ewjf4 http://www.girinst.org/server/RepBase/protected/RepBase22.01.embl.tar.gz
wget --quiet --user wivill --password 0ewjf4 http://www.girinst.org/server/RepBase/protected/RepBase22.01.fasta.tar.gz
wget --quiet --user wivill --password 0ewjf4 http://www.girinst.org/server/RepBase/protected/REPET/RepBase20.05_REPET.embl.tar.gz
wget --quiet --user wivill --password 0ewjf4 http://www.girinst.org/server/RepBase/openaccess/dfamrepref.embl.tgz
tar -xvzf RepBase22.01.fasta.tar.gz
tar -xvzf RepBaseRepeatMaskerEdition-20170127.tar.gz
tar -xvzf RepBase22.01.embl.tar.gz
tar -xvzf RepBase20.05_REPET.embl.tar.gz
tar -xvzf dfamrepref.embl.tgz
wget --quiet http://www.dfam.org/web_download/Current_Release/Dfam.hmm.gz
gunzip Dfam.hmm.gz
cd Libraries
mv Dfam.hmm Dfam.hmm.old
mv ../Dfam.hmm .
cd ..

mkdir -p /opt/tools/modulefiles/RepeatMasker

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/RepeatMasker/4.0.6
#%Module#####################################################################
## RepeatMasker
set version 4.0.6
proc ModulesHelp { } {
puts stderr "This module enables the use of Repeat Masker software."
puts stderr "Compiled with RMBlast+patch."
}
module-whatis "RepeatMasker"
set prefix /opt/tools/RepeatMasker
prepend-path CPATH ${prefix}/include
prepend-path PATH ${prefix}:${prefix}/bin
prepend-path LD_LIBRARY_PATH ${prefix}/Libraries
prepend-path LIBRARY_PATH ${prefix}/Libraries
prepend-path MANPATH ${prefix}/share/man/
#EOF#

/bin/cat <<"#EOF#" > /opt/tools/modulefiles/RepeatMasker/.modulerc
#%Module
if {![info exists rms-done]} {
module-version rms/4.0.6 4.0
module-version rms/4.0 default
set rms-done 1
}
#EOF#
