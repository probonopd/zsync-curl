#!/bin/bash

# If we are running a system with apt-get and missing dependencies, install them
which apt-get && ( sudo apt-get -y install automake autoconf libtool )
which apt-get && ( pkg-config --libs libcurl || sudo apt-get -y install libcurl4-gnutls-dev )
which apt-get && ( which gcc || sudo apt-get -y install gcc )

# If we are running a system with yum and missing dependencies, install them
which yum && ( sudo yum -y install automake autoconf libtool )
which yum && ( pkg-config --libs libcurl || sudo yum -y install libcurl-devel )
which yum && ( which gcc || sudo yum -y install gcc )

cd "$(dirname "${0}")/src"
export CFLAGS=--std=c99 # zsync_curl does not compile if the compiler is not explicitly told that this is c99 code 
autoreconf -if && ./configure && make && sudo make install
cd -
