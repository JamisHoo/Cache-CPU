/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: COM DEBUG TOOL
 *  Filename: recv.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 01, 2014
 *  Time: 12:19:30
 *  Description: receive bytes from serial port.
 *****************************************************************************/
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <cstring>
#include <cstdint>
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
    if (getuid()) {
        std::cout << "Need root privilage. " << std::endl;
        return 1;
    }

    int com;
    if((com = open(MODEM , O_RDWR | O_NONBLOCK)) == -1){
        std::cout << "Error while opening serial port. " << std::endl;
        return 2;
    }

    // serial port settings
    struct termios port_settings;
    memset(&port_settings, 0, sizeof(port_settings));
    port_settings.c_iflag = 0;
    port_settings.c_oflag = 0;
    port_settings.c_cflag = CS8 | CREAD | CLOCAL;
    port_settings.c_lflag = 0;
    port_settings.c_cc[VMIN] = 1;
    port_settings.c_cc[VTIME] = 5;
    cfsetospeed(&port_settings, B38400);
    cfsetispeed(&port_settings, B38400);
    tcsetattr(com, TCSANOW, &port_settings);

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
    return 0;
}

