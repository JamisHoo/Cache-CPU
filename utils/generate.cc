/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: 
 *  Filename: generate.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Nov. 12, 2014
 *  Time: 10:53:54
 *  Description: 
 *****************************************************************************/
#include <iostream>

int main() {
    for (int i = 0; i < 8192 * 8; ++i) 
        std::cout << char(i);
}
