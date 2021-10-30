cmake_minimum_required(VERSION 3.12)

include(CheckIncludeFile)
CHECK_INCLUDE_FILE("inttypes.h" HAVE_INTTYPES_H)

add_library(rcksum)
add_library(Librcksum::librcksum ALIAS rcksum)
target_sources(rcksum PRIVATE rsum.c hash.c state.c range.c md4.c ../zsglobal.h)
target_include_directories(rcksum
    PUBLIC
        ..
)

# TODO: as test
add_executable(md4test md4test.c md4.c)
target_include_directories(md4test
    PRIVATE
        ..
)

if(HAVE_INTTYPES_H)
    target_compile_definitions(rcksum PUBLIC HAVE_INTTYPES_H=1)
    target_compile_definitions(md4test PRIVATE HAVE_INTTYPES_H=1)
endif()
