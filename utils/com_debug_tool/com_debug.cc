/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: COM DEBUG
 *  Filename: chedan.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 16, 2014
 *  Time: 19:03:47
 *  Description: compile with -lpthread to enable multithread
 *****************************************************************************/
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <cstring>
#include <cstdint>
#include <iostream>
#include <cstdlib>
#include <thread>
#include <cstdint>

// serial port dev
const char* MODEM = "/dev/ttyUSB0";

// block until receive a byte from serial port
uint8_t receive(const int com) {
    char buff[1];
    while (read(com, buff, 1) <= 0);
    return buff[0];
}

// send a byte to serial port
inline void send(const uint8_t x, const int com) {
    char buff[1];
    buff[0] = x;
    write(com, buff, 1);
}


int main(int argc,char** argv) {   
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

    std::cout << "Prepared to send and receive... " << std::endl;


    auto send_command = [&com]() {
        // send CMD_LENGTH bytes each time
        constexpr int CMD_LENGTH = 8;
        uint8_t cmd[CMD_LENGTH];
        std::string buff;
        // keep reading and sending
        while (1) {
            // block until get CMD_LENGTH numbers
            for (int i = 0; i < CMD_LENGTH; ++i) {
                std::cin >> buff;
                cmd[i] = std::stoi(buff, nullptr, 0);
            }
            // send all CMD_LENGTH bytes at once
            std::cout << "Send(hexadecimal): ";
            for (int i = 0; i < CMD_LENGTH; ++i) {
                send(cmd[i], com);
                printf("%02x ", int(cmd[i]) & 0xff);
                fflush(stdout);
            }
            std::cout << std::endl;
        }
    };

    auto recv_data = [&com]() {
        int count = 0;
        while (1) {
            printf("%02x", receive(com) & 0xff);
            fflush(stdout);
            if (++count == 12) {
                count = 0;
                printf("\n");
            }
        }
    };

    std::thread send_thread(send_command);
    std::thread recv_thread(recv_data);

    send_thread.join();
    recv_thread.join();
    close(com);
    return 0;
}

