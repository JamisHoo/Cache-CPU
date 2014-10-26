#!/bin/bash -e
# $File: compile_userapp.sh
# $Date: Sat Dec 21 21:04:16 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>
export CFLAGS="-Iuser/libs -Ikern/include"
export LDFLAGS=obj/user/libuser.a
$(dirname $0)/compile_userapp_raw.sh "$@"
