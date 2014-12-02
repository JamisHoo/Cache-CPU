/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: Com To Flash
 *  Filename: com2flash.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 02, 2014
 *  Time: 10:57:35
 *  Description: Write, read or erase flash via serial port.
 *               Usage: ./com2flash read <addr> <length> <file>
 *                      ./com2flash write <addr> <length> <file>
 *                      ./com2flash erase <addr> <length>
 *****************************************************************************/
#include <unistd.h>
#include <fcntl.h>
#include <iostream>
#include <cstdlib>

const char* MODEM = "/dev/ttyUSB0";

uint8_t receive(const int com) {
    char buff[1];
    while (read(com, buff, 1) <= 0);
    return buff[0];
}

int main(int argc,char** argv)
{   
    using namespace std;
    if ((argc != 4 && argc != 5) || 
        (string(argv[1]) != "read" && string(argv[1]) != "write" && string(argv[1]) != "erase") ||
        (string(argv[1]) == "read" && argc != 5) ||
        (string(argv[1]) == "write" && argc != 5) ||
        (string(argv[1]) == "erase" && argc != 4)) {
        printf("Usage: %s read  <addr> <length> <file>. \n", argv[0]);
        printf("       %s write <addr> <length> <file>. \n", argv[0]);
        printf("       %s erase <addr> <length> <file>. \n", argv[0]);
        return 1;
    }

    int addr = stoi(string(argv[2]));
    int length = stoi(string(argv[3]));
    string filename = argc == 5? argv[4]: "";

    cout << addr << endl << length << endl << filename << endl;

    if (addr & 1 || length & 1) {
        cout << "Address must be 2-aligned. " << endl;
        return 0;
    }

    if (getuid()) {
        std::cout << "Need root privilage. " << std::endl;
        return 1;
    }

    /*
    int com;
    if((com = open(MODEM , O_RDWR | O_NONBLOCK)) == -1){
        std::cout << "Error while opening serial port. " << std::endl;
        return 2;
    }

    std::cout << "Prepared to receive... " << std::endl;

    int count = 0; 
    while (1) {
        printf("%02x", receive(com) & 0xff);
        if (++count == 12) {
            printf("\n");
            count = 0;
        }
    }

    close(com);
    */
    return 0;
}

