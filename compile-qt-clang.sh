#!/bin/bash
ARCHIVE="tar.*"
BUNDLE="qt-everywhere-opensource-src-"
SOURCE=$(ls -r $BUNDLE*$ARCHIVE | head -n 1)
TARGET=/tmp/build/${SOURCE%%.$ARCHIVE}
VERSION=${SOURCE##$BUNDLE}
VERSION=${VERSION%%.$ARCHIVE}

if [ -z $SOURCE ]; then
	echo "Unable to find qt sources."
	exit
fi

mkdir -p $TARGET > /dev/null
tar xf $SOURCE -C $TARGET --strip 1

pushd "$TARGET"
./configure -prefix /opt/qt-$VERSION-clang -platform linux-clang -opensource -confirm-license
gmake -j5
gmake install
popd
