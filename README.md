# zsync-curl

Partial/differential file download client over HTTP(S).

Downloads a file over HTTP(S). zsync uses a control file to determine whether any blocks in the file are already known to the downloader, and only downloads the new blocks. 

This fork uses [libcurl](http://curl.haxx.se/libcurl/) in order to support __HTTPS__ and is mirrored from [Launchpad](https://launchpad.net/zsync-curl). It has been further modified to respond more gracefully to redirects.

## Building

To build:
```
git clone https://github.com/probonopd/zsync-curl.git
./zsync-curl/build.sh
```

## Usage

To download:

```
zsync_curl https://bintray.com/artifact/download/probono/AppImages/Leafpad-0.8.17-x86_64.AppImage.zsync
```

To download using a pre-existing seed file (e.g., older version of the same file):

```
zsync_curl https://bintray.com/artifact/download/probono/AppImages/Scribus-1.5.1.svn.20620-x86_64.AppImage.zsync -i Scribus-1.5.1.svn.20616-x86_64.AppImage
```

In this example, 94% of the data can be taken from the existing local file, and only 6% need to be downloaded.
