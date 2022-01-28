cmake_minimum_required(VERSION 3.12)

include(CheckIncludeFile)
CHECK_INCLUDE_FILE("inttypes.h" HAVE_INTTYPES_H)

add_library(zsync)
add_library(Zsync::zsync ALIAS zsync)
target_sources(zsync PRIVATE zsync.h zsync.c zmap.c sha1.c)
target_include_directories(zsync
    PUBLIC
        ..
)

# TODO: as test
add_executable(sha1test sha1test.c sha1.c)
target_include_directories(sha1test
    PRIVATE
        ..
)

if(HAVE_INTTYPES_H)
    target_compile_definitions(zsync PRIVATE HAVE_INTTYPES_H=1)
    target_compile_definitions(sha1test PRIVATE HAVE_INTTYPES_H=1)
endif()


