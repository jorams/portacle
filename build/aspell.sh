#!/bin/bash

readonly TAG=0.60.6.3
readonly REPOSITORY=https://github.com/Shinmera/aspell
readonly CONFIGURE_OPTIONS="--disable-shared --disable-rpath"

###

readonly PROGRAM=aspell
source common.sh
INSTALL_DIR="$PORTACLE_DIR/$PROGRAM/"

case "$PLATFORM" in
    win) CONFIGURE="$CONFIGURE_OPTIONS --disable-nls" ;;
    *)   CONFIGURE="$CONFIGURE_OPTIONS" ;;
esac

function prepare() {
    cd "$SOURCE_DIR"
    ./autogen
    ./configure --prefix="/$PLATFORM" --sysconfdir="/share" --datarootdir="/share" \
                --enable-pkgdatadir="/share" --enable-pkglibdir="/share" \
                $CONFIGURE \
        || eexit "Configure failed. Maybe some dependencies are missing?"
}

function build() {
    cd "$SOURCE_DIR"
    make -j $MAXCPUS \
        || eexit "The build failed. Please check the output for error messages."
}

function install() {
    cd "$SOURCE_DIR"
    make DESTDIR="$INSTALL_DIR" install \
        || eexit "The install failed. Please check the output for error messages."    
    
    ensure-dependencies $(find-binaries "$INSTALL_TARGET/")
}

main