#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

TOOLCHAIN=${1}
NAME=${TOOLCHAIN##.*}
NAME=${NAME%%.*}

if [ -z $TOOLCHAIN ]; then
	echo "Toolchain must be defined in first parameter."
	exit 1
fi

if [ ! -f $TOOLCHAIN ]; then
	echo "Toolchain do not exists."
	exit 1
fi

echo "Toolchain: ${TOOLCHAIN}"
echo "Name: ${NAME}"

MOUNT_ROOT=/mnt/$NAME
MOUNT_DEV=$MOUNT_ROOT/dev
MOUNT_SYS=$MOUNT_ROOT/sys
MOUNT_PROC=$MOUNT_ROOT/proc
MOUNT_DEVPTS=$MOUNT_DEV/pts
MOUNT_TMPFS1=$MOUNT_ROOT/var/tmp
MOUNT_TMPFS2=$MOUNT_ROOT/tmp

function mnt {
  if ! mountpoint -q $2 ; then
    mount -o bind $1 $2
    echo "binding ${1} to ${2}"
  else
    echo "${1} already binded in ${2}"
  fi
}

mkdir -p $MOUNT_ROOT &> /dev/null

if ! mountpoint -q $MOUNT_ROOT ; then
  mount $TOOLCHAIN $MOUNT_ROOT
  mnt /dev $MOUNT_DEV
  mnt /sys $MOUNT_SYS
  mnt /proc $MOUNT_PROC
  mnt /dev/pts $MOUNT_DEVPTS
  mnt /var/tmp $MOUNT_TMPFS1
  mnt /tmp $MOUNT_TMPFS2
fi

chroot $MOUNT_ROOT /bin/bash

while true; do
    read -p "Do you want to umount all directories [y/n]? " yn
    case $yn in
        [Yy]* )
		umount $MOUNT_DEVPTS
		umount $MOUNT_TMPFS1
  		umount $MOUNT_TMPFS2
  		umount $MOUNT_PROC
  		umount $MOUNT_SYS
  		umount $MOUNT_DEV
  		umount $MOUNT_ROOT
 		break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
