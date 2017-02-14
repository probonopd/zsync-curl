#!/bin/bash

# Build in a way to support SSH but use an external OpenSSL library

# If we are running a system with apt-get and missing dependencies, install them
which apt-get && ( sudo apt-get -y install automake autoconf libtool )
which apt-get && ( which gcc || sudo apt-get -y install gcc )

# If we are running a system with yum and missing dependencies, install them
which yum && ( sudo yum -y install automake autoconf libtool )
which yum && ( which gcc || sudo yum -y install gcc )

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

sudo ldconfig

# Build libcurl with wolfssl
git clone https://github.com/bagder/curl.git # In commit 1ff3a07 it should now handle wolfssl builds without SSLv3
cd curl/
./buildconf
./configure  --enable-optimize --disable-dict --disable-gopher --disable-ftp --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --disable-zlib --without-ca-bundle --without-gnutls --without-libidn --without-librtmp --without-libssh2 --without-nss --with-ssl --without-zlib --disable-shared --without-cyassl
sed -i -e 's|//#define HAVE_CLOCK_GETTIME_MONOTONIC|#define HAVE_CLOCK_GETTIME_MONOTONIC|g' lib/curl_config.h
make
sudo make install
cd -

sudo ldconfig

cd src
export CFLAGS=--std=c99 # zsync_curl does not compile if the compiler is not explicitly told that this is c99 code 
./configure 
make || true

gcc -g -O2 -g -Wall -Wwrite-strings -Winline -Wextra -Winline -Wmissing-noreturn -Wredundant-decls -Wnested-externs -Wundef -Wbad-function-cast -Wcast-align -Wvolatile-register-var -ffast-math   -o zsync_curl client.o http.o url.o progress.o base64.o libzsync/libzsync.a librcksum/librcksum.a zlib/libinflate.a /usr/local/lib/libcurl.a -lrt -lm

strip zsync_curl

ls -lh zsync_curl 

ldd zsync_curl 

strings zsync_curl | grep GLIBC_ | sort -V | tail -n 1
