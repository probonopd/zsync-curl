cmake_minimum_required(VERSION 3.8)
project(zsync-curl LANGUAGES C)

add_definitions(-DPACKAGE="zsync_curl" -DVERSION="0.6.2")
set(CMAKE_C_STANDARD 99)

add_subdirectory(librcksum)
add_subdirectory(zlib)
add_subdirectory(libzsync)
#add_subdirectory(doc)

include(CheckSymbolExists)
include(CheckTypeSize)

check_symbol_exists(getaddrinfo "netdb.h" HAVE_GETADDRINFO)
CHECK_TYPE_SIZE(off_t SIZEOF_OFF_T)

add_definitions(-DSIZEOF_OFF_T=${SIZEOF_OFF_T})

add_executable(zsync_curl client.c http.c url.c progress.c base64.c)
set_target_properties(zsync_curl PROPERTIES OUTPUT_NAME "zsync")


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
set_target_properties(zsyncmake_curl PROPERTIES OUTPUT_NAME "zsyncmake")
target_link_libraries(zsyncmake_curl
    PRIVATE
        Zsync::zsync
        Librcksum::librcksum
        Zlib::inflate
        Zlib::deflate
        m
)

install(
    TARGETS
        zsync_curl
        zsyncmake_curl
    RUNTIME DESTINATION
        bin
)

