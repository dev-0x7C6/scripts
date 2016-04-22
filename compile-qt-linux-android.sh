#!/bin/bash
PLATFORM="${0##*compile-qt-}"
PLATFORM="${PLATFORM%%.sh}"
ARCHIVE="tar.*"
BUNDLE="qt-everywhere-opensource-src-"
SOURCE=$(ls -r $BUNDLE*$ARCHIVE | head -n 1)
TARGET=/tmp/build/${PLATFORM}/${SOURCE%%.$ARCHIVE}
VERSION=${SOURCE##$BUNDLE}
VERSION=${VERSION%%.$ARCHIVE}

echo "Platform: ${PLATFORM}"
echo "Selected version: ${VERSION}"

if [ -z $SOURCE ]; then
	echo "Unable to find qt sources."
	exit
fi

mkdir -p $TARGET > /dev/null
tar xf $SOURCE -C $TARGET --strip 1

pushd "$TARGET"
./configure -prefix /opt/qt/$VERSION-$PLATFORM -xplatform android-g++ -nomake tests -nomake examples -android-ndk /opt/android-ndk -android-sdk /opt/android-sdk-update-manager -android-ndk-host linux-x86_64 -android-toolchain-version 4.9 -skip qttranslations -no-warnings-are-errors -no-harfbuzz
make -j6
make -j1 install
popd
