#!/bin/bash -e
# $File: write_to_flash.sh
# $Date: Tue Dec 10 22:28:19 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>


MEMTRANS=../utils/memtrans/controller.py
OBJ=obj/ucore-kernel-initrd
[ $# = 1 ] && export DEVICE=$1

$MEMTRANS flash erase 0 $(ls -al $OBJ | cut -d' ' -f 5)
$MEMTRANS flash write 0 $OBJ
md5sum $OBJ

