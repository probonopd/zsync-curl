cmake_minimum_required(VERSION 3.8)
project(mxnet6000 LANGUAGES C)

add_definitions(-DPACKAGE="zsync_curl" -DVERSION="0.6.2")

add_subdirectory(librcksum)
add_subdirectory(zlib)
add_subdirectory(libzsync)
#add_subdirectory(doc)

include(CheckSymbolExists)
check_symbol_exists(getaddrinfo "netdb.h" HAVE_GETADDRINFO)

add_executable(zsync_curl client.c http.c url.c progress.c base64.c)


if(HAVE_GETADDRINFO)
    target_compile_definitions(zsync_curl PRIVATE HAVE_GETADDRINFO=1)
endif()

target_link_libraries(zsync_curl
    PRIVATE
        Zsync::zsync
        Librcksum::librcksum
        Zlib::inflate
        Zlib::deflate
        curl
)

add_executable(zsyncmake_curl make.c makegz.c)
target_link_libraries(zsyncmake_curl
    PRIVATE
        Zsync::zsync
        Librcksum::librcksum
        Zlib::inflate
        Zlib::deflate
        m
)

#zsync_curl_LDADD = libzsync/libzsync.a librcksum/librcksum.a zlib/libinflate.a $(LIBOBJS)

