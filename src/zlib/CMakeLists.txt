cmake_minimum_required(VERSION 3.12)

include(CheckIncludeFile)
CHECK_INCLUDE_FILE("inttypes.h" HAVE_INTTYPES_H)

add_library(inflate)
add_library(Zlib::inflate ALIAS inflate)
target_sources(inflate PRIVATE inflate.c adler32.c inftrees.c zutil.c crc32.c)

add_library(deflate)
add_library(Zlib::deflate ALIAS deflate)
target_sources(deflate PRIVATE deflate.c compress.c trees.c)


