#!/bin/bash

NAME="compiler-performance-platform"
REPO="https://github.com/dev-0x7C6/${NAME}.git"
COUNT=1000

GCC_COUNT=$(gcc-config -l | wc -l)
GCC_QMAKE="/usr/lib/qt5/bin/qmake"
CLANG_QMAKE="/opt/qt/5.5.1-linux-clang/bin/qmake"

CXXFLAGS_MATCH="-std=c++14 -march=native -O3 -pipe -fomit-frame-pointer"
CXXFLAGS_ARRAY=(
	"-std=c++14 -march=native -O3"
	"-std=c++14 -march=native -O2"
	"-std=c++14 -march=native -O1"
)

compile() {
	pushd /tmp
	mkdir tests
	pushd tests

	git clone $REPO $NAME
	pushd $NAME
	git reset --hard
	git clean -d -f -x

	sed "s/${CXXFLAGS_MATCH}/${2}/g" cflags.pri > cflags.pri.bak
	cp -f cflags.pri.bak cflags.pri
	$1 "${NAME}.pro"
	make all -j8

	./$NAME $COUNT

	popd
	popd
	popd
}


for i in $(seq 1 $GCC_COUNT)
do
	gcc-config -f $i
	source /etc/profile

	for j in "${CXXFLAGS_ARRAY[@]}"
	do
		compile $GCC_QMAKE "${j}"
	done
done

for j in "${CXXFLAGS_ARRAY[@]}"
do
	compile $CLANG_QMAKE "${j}"
done
