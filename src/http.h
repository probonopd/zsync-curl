/*
 *   http.h - simple HTTP client for zsync
 *
 *   Copyright (C) 2004,2005,2009 Colin Phipps <cph@moria.org.uk>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the Artistic License v2 (see the accompanying 
 *   file COPYING for the full license terms), or, at your option, any later 
 *   version of the same license.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   COPYING file for details.
 */



extern char *referer;
extern char *redirected;
extern int use_redirected;
extern int http_ssl_insecure;
extern int http_verbose;
extern const char* http_clientauth_key;
extern const char* http_clientauth_cert;
extern const char* http_cacert;
extern const char* http_unix_socket_path;
extern char *cookie;

int set_proxy_from_string(const char* s);

FILE* http_get(const char* orig_url, char** track_referer, const char* tfname);

struct range_fetch;

struct range_fetch* range_fetch_start(const char* orig_url);
void range_fetch_addranges(struct range_fetch* rf, off_t* ranges, int nranges);
int get_range_block(struct range_fetch* rf, off_t* offset, unsigned char* data, size_t dlen);
off_t range_fetch_bytes_down(const struct range_fetch* rf);
void range_fetch_end(struct range_fetch* rf);

void add_auth(char* host, char* user, char* pass);

/* base64.c */
char* base64(const char*);

