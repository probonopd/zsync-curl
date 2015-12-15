#!/bin/bash

# If we are running a system with apt-get and missing dependencies, install them
which apt-get && ( pkg-config --libs libcurl || sudo apt-get -y install libcurl4-gnutls-dev )
which apt-get && ( which gcc || sudo apt-get -y install gcc )

# If we are running a system with yum and missing dependencies, install them
which yum && ( pkg-config --libs libcurl || sudo yum -y install libcurl-devel )
which yum && ( which gcc || sudo yum -y install gcc )

cd "$(dirname "${0}")/src"
./configure && make && sudo make install
cd -
