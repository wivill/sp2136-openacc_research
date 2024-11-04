#!/bin/bash

cd /home
for h in * ; do
	echo "source /opt/intel/bin/compilervars.sh intel64" >> /home/${h}/.bash_profile
done