#!/bin/bash

NAME="compiler-performance-platform"
REPO="https://github.com/dev-0x7C6/${NAME}.git"
COUNT=$1
COUNT=${COUNT:=10}

CXXFLAGS_MATCH="-std=c++14 -march=native -O3 -pipe -fomit-frame-pointer"
CXXFLAGS_ARRAY=(
	"-std=c++14 -march=native -O3"
	"-std=c++14 -march=native -O2 -flto"
	"-std=c++14 -march=native -O1"
	"-std=c++14 -march=native -Os"
	"-std=c++14 -march=native -Ofast"
	"-std=c++14 -O3"
	"-std=c++14 -O2 -flto"
	"-std=c++14 -O1"
	"-std=c++14 -Os"
	"-std=c++14 -Ofast"
)
QMAKE_ARRAY=(
	"/opt/qtsdk/qtsdk-linux-g++-5.6.0/bin/qmake"
	"/opt/qtsdk/qtsdk-linux-clang-5.6.0/bin/qmake"
)

compile() {
	local workdir="/tmp/${NAME}"
	git clone $REPO $workdir
	pushd $workdir
	git reset --hard
	git clean -d -f -x
	git pull

	sed "s/${CXXFLAGS_MATCH}/${2}/g" cflags.pri > cflags.pri.bak
	cp -f cflags.pri.bak cflags.pri
	$1 "${NAME}.pro"
	make all -j8
	./$NAME $COUNT
	rm $NAME
	make distclean

	popd
}

for gcc_id in $(seq 1 $(gcc-config -l | wc -l))
do
	gcc-config -f $gcc_id
	source /etc/profile

	for qmake_bin in "${QMAKE_ARRAY[@]}"
	do
		for cxxflags in "${CXXFLAGS_ARRAY[@]}"
		do
			compile "${qmake_bin}" "${cxxflags}" 
		done
	done
done
