#!/bin/bash

# Build in a way to support SSH but minimize dependencies
# GLIBC_2.14 is needed at the moment because wolfssl seems to need it
# When using LibcWrapGenerator I get
# libzsync/sha1.c:152: undefined reference to `memcpy@GLIBC_DONT_USE_THIS_VERSION_2.14'

# However, when using this I get:
# curl: (77) 	CA signer not available for verification

# If we are running a system with apt-get and missing dependencies, install them
which apt-get && ( sudo apt-get -y install automake autoreconf libtool )
which apt-get && ( which gcc || sudo apt-get -y install gcc )

# If we are running a system with yum and missing dependencies, install them
which yum && ( sudo yum -y install automake autoreconf libtool )
which yum && ( which gcc || sudo yum -y install gcc )

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig/

# Build wolfssl
git clone https://github.com/wolfSSL/wolfssl.git
cd wolfssl/
./autogen.sh
./configure --disable-shared --enable-static --enable-ecc --enable-crl --enable-sni --enable-aesgcm --enable-dsa --disable-arc4 --enable-opensslextra
make
sudo make install
cd -

sudo ldconfig

# Build libcurl with wolfssl
git clone https://github.com/bagder/curl.git # In commit 1ff3a07 it should now handle wolfssl builds without SSLv3
cd curl/
./buildconf
./configure  --enable-optimize --disable-dict --disable-gopher --disable-ftp --disable-imap --disable-ldap --disable-ldaps --disable-pop3 --disable-proxy --disable-rtsp --disable-smtp --disable-telnet --disable-tftp --disable-zlib --without-ca-bundle --without-gnutls --without-libidn --without-librtmp --without-libssh2 --without-nss --without-ssl --without-zlib --disable-shared --with-cyassl
sed -i -e 's|//#define HAVE_CLOCK_GETTIME_MONOTONIC|#define HAVE_CLOCK_GETTIME_MONOTONIC|g' lib/curl_config.h
make
sudo make install
cd -

sudo ldconfig

cd zsync-curl/src

./configure 
make

# This builds against the wrong (non-static) system-provided libcurl, 
# but we can do the final step manually (FIXME):
# If we had built wolfssl without the "--disable-shared" above, we could now 
# use libwolfssl.so instead of libwolfssl.a and get a dependency on libwolfssl.so
# which would save around 300K in the binary but add a 400K dependency
gcc -g -O2 -g -Wall -Wwrite-strings -Winline -Wextra -Winline -Wmissing-noreturn -Wredundant-decls -Wnested-externs -Wundef -Wbad-function-cast -Wcast-align -Wvolatile-register-var -ffast-math   -o zsync_curl client.o http.o url.o progress.o base64.o libzsync/libzsync.a librcksum/librcksum.a zlib/libinflate.a /usr/local/lib/libcurl.a /usr/local/lib/libwolfssl.a -lrt -lm

strip zsync_curl

ls -lh zsync_curl 
# -rwxrwxr-x 1 me me 604K 16. Dez 16:54 zsync_curl

ldd zsync_curl 
#	linux-vdso.so.1 (0x00007ffc89238000)
#	librt.so.1 => /lib64/librt.so.1 (0x00007f00747fc000)
#	libm.so.6 => /lib64/libm.so.6 (0x00007f00744fa000)
#	libc.so.6 => /lib64/libc.so.6 (0x00007f0074138000)
#	libpthread.so.0 => /lib64/libpthread.so.0 (0x00007f0073f1b000)
#	/lib64/ld-linux-x86-64.so.2 (0x00005559e4b83000)

strings zsync_curl | grep GLIBC_ | sort -V | tail -n 1
# GLIBC_2.14
