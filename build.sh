#!/bin/bash

# If we are running a system with apt-get and missing dependencies, install them
which apt-get && ( pkg-config --libs libcurl || sudo apt-get-y install libcurl4-gnutls-dev )
which apt-get && ( which gcc || sudo apt-get -y install gcc )

sudo apt-get -y install libcurl4-gnutls-dev
cd src/
./configure && make && sudo make install
cd -
