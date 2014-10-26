#!/bin/bash -e
# $File: compile_userapp_raw.sh
# $Date: Sat Dec 21 21:04:43 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

GCCPREFIX=mips-sde-elf-

LD=${GCCPREFIX}ld
CC=${GCCPREFIX}gcc
[ -z "$OPTFLAG" ]  && OPTFLAG=-O2
CFLAGS="-mips1 $OPTFLAG $CFLAGS -fno-builtin -nostdlib  -nostdinc -G0 -Wformat -EL -Wall -Werror"

src=$1
out=$2
obj=${out}.o


if [ -z "$out" ]
then
	echo "usage: $0 <.c source file> <output file>"
	exit
fi

set -x
$CC -c $src -DUSER_PROG $CFLAGS -o $obj
$LD -S -T $(dirname $0)/user/libs/user.ld $obj $LDFLAGS -o $out
rm -f $obj
