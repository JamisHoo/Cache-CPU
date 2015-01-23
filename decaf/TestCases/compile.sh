#!/bin/sh
###############################################################################
 #  Copyright (c) 2015 Jinming Hu 
 #  Distributed under the MIT license 
 #  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 #  
 #  Project: Decaf
 #  Filename: compile.sh 
 #  Version: 1.0
 #  Author: Jinming Hu
 #  E-mail: hjm211324@gmail.com
 #  Date: Jan. 23, 2015
 #  Time: 10:14:10
 #  Description: compile .decaf to .S
###############################################################################

if [ $# -lt 2 ]
    then echo "Usage: ./$0 <decaf source file> <target file>" 
    exit
fi

java -jar ../result/decaf.jar $1 -l 4 > $2.S
