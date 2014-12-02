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
#include <fstream>
#include <cstdlib>
#include <cstdio>
#include <cassert>

const char* MODEM = "/dev/ttyUSB0";

inline uint8_t receive(const int com) {
    char buff[1];
    while (read(com, buff, 1) <= 0);
    return buff[0];
}

inline void send(const uint8_t x, const int com) {
    printf("%02x\n", x);
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
        printf("Address and length must be 2-aligned positive number. "
               "Octal, decimal or hexadecimal supoorted. \n");
        return 1;
    }

    int ope_type;
    if (string(argv[1]) == "read") ope_type = 0;
    else if (string(argv[1]) == "write") ope_type = 1;
    else if (string(argv[1]) == "erase") ope_type = 2;
    else ope_type = -1;

    int addr = stoi(string(argv[2]), nullptr, 0);
    int length = stoi(string(argv[3]), nullptr, 0);
    string filename = argc == 5? argv[4]: "";

    if (addr & 1 || length & 1) {
        cout << "Address must be 2-aligned. " << endl;
        return 2;
    } else if (addr < 0 || length < 0) {
        cout << "Address must be positive. " << endl;
        return 3;
    } else if (addr + length > 8 * 1024 * 1024) {
        cout << "Address should be in [0, 0x800000). " << endl;
        return 4;
    }

    if (getuid()) {
        std::cout << "Root privilage required. " << std::endl;
        return 5;
    }

    
    // oepn serial port
    int com;
    /*
    if((com = open(MODEM , O_RDWR | O_NONBLOCK)) == -1){
        std::cout << "Error while opening serial port. " << std::endl;
        return 6;
    }
    */

    switch (ope_type) {
        // read
        case 0: {
            // send read signal
            send(0xAA, com);
            // send start address
            send((addr >> 17) & 0xFF, com);
            send((addr >>  9) & 0xFF, com);
            send((addr >>  1) & 0xFF, com);
            // send end address
            send((addr + length >> 17) & 0xFF, com);
            send((addr + length >>  9) & 0xFF, com);
            send((addr + length >>  1) & 0xFF, com);

            ofstream fout(filename, ofstream::out | ofstream::binary);
            for (int i = 0; i < length; ++i) {
                char buff = receive(com);
                fout.write(&buff, 1);
            }
            break;
        }
        // write
        case 1:
        // erase
        case 2:
            cout << "Not supported for now. " << endl;
            break;
        default:
            assert(0);
    }



    // close(com);
    
    return 0;
}

