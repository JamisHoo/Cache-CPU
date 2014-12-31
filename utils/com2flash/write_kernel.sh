#!/bin/sh
###############################################################################
 #  Copyright (c) 2014 Jinming Hu 
 #  Distributed under the MIT license 
 #  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 #  
 #  Project: 
 #  Filename: write_kernel.sh 
 #  Version: 1.0
 #  Author: Jinming Hu
 #  E-mail: hjm211324@gmail.com
 #  Date: Dec. 31, 2014
 #  Time: 14:49:13
 #  Description: 
###############################################################################

if [ "$EUID" -ne 0 ]
    then echo "Need root privilege "
    exit
fi

if [ $# -lt 1 ]
    then echo "One argument is require. "
    exit
fi

python controller.py flash erase 0 0x150000
python controller.py flash write 0 $1
