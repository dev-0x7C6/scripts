#!/bin/bash
PLATFORM="${0##*compile-qt-}"
PLATFORM="${PLATFORM%%.sh}"
ARCHIVE="tar.*"
BUNDLE="qt-everywhere-opensource-src-"
SOURCE=$(ls -r $BUNDLE*$ARCHIVE | head -n 1)
TARGET=/tmp/build/${SOURCE%%.$ARCHIVE}
VERSION=${SOURCE##$BUNDLE}
VERSION=${VERSION%%.$ARCHIVE}

echo "Selected version: ${VERSION}"

if [ -z $SOURCE ]; then
	echo "Unable to find qt sources."
	exit
fi

mkdir -p $TARGET > /dev/null
tar xf $SOURCE -C $TARGET --strip 1

pushd "$TARGET"
./configure -prefix /opt/qt/$VERSION-$PLATFORM -platform $PLATFORM -opensource -confirm-license
make -j6
make -j1 install
popd
