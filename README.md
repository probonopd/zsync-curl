# zsync-curl

Partial/differential file download client over HTTP(S).

Downloads a file over HTTP(S). zsync uses a control file to determine whether any blocks in the file are already known to the downloader, and only downloads the new blocks. 

This fork uses [libcurl](http://curl.haxx.se/libcurl/) in order to support __HTTPS__ and is mirrored from [Launchpad](https://launchpad.net/zsync-curl).

## Building

To build:
```
sudo yum -y install git 
git clone https://github.com/probonopd/zsync-curl.git
./zsync-curl/build.sh
```
To build on __Ubuntu__:
```
sudo apt-get -y install libcurl4-gnutls-dev git gcc
git clone https://github.com/probonopd/zsync-curl.git
./zsync-curl/build.sh
```
