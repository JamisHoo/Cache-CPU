/******************************************************************************
 *  Copyright (c) 2014 Jamis Hoo 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: Cache Debugger
 *  Filename: com_comm.h 
 *  Version: 1.0
 *  Author: Jamis Hoo
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 31, 2014
 *  Time: 19:07:03
 *  Description: 
 *****************************************************************************/
#ifndef COM_COMM_H_
#define COM_COMM_H_

#include <unistd.h>
#include <sys/time.h>
#include <fcntl.h>
#include <termios.h>
#include <cstdlib>
#include <cassert>
#include <memory>
#include <algorithm>

class Communicator {
    
public:
    Communicator(const int sps, const int rps): 
        _send_packet_size(sps), _recv_packet_size(rps), _com(0), 
        _buffer(new char[rps]) {
    }

    ~Communicator() {
        close(_com);
    }

    bool open(const char* dev, const int /* baudrate */) {
        if ((_com = ::open(dev, O_RDWR | O_NONBLOCK)) == -1) 
            return 1;

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
        tcsetattr(_com, TCSANOW, &port_settings);   

        return 0;
    }

    void send(const std::string& cmd) {
#ifdef DEBUG
        std::cout << "Sending data: ";
        for (std::size_t i = 0; i < cmd.length(); ++i) 
            printf("%02x ", int(cmd[i]) & 0xff);
        std::cout << std::endl;
#endif
            
        assert(int(cmd.length()) == _send_packet_size);
        for (const auto c: cmd) send(c);
    }

    std::string recv() const {
        // return std::string(_recv_packet_size, '0');
        for (int i = 0; i < _recv_packet_size; ++i)
            _buffer[i] = receive();
#ifdef DEBUG
        std::cout << "Receive data: ";
        for (int i = 0; i < _recv_packet_size; ++i)
            printf("%02x ", int(_buffer[i]) & 0xff);
        std::cout << std::endl;
#endif

        return std::string(_buffer.get(), _recv_packet_size);
    }
    
    void clearSystemBuff() const {
        int count = 0;
        char buff;
        uintmax_t start = getTime();
        while (true) {
            if (read(_com, &buff, 1) <= 0) {
                uintmax_t now = getTime();
#ifdef DEBUG
                std::cout << "Now: " << now << ", Start: " << start << std::endl;
#endif
                if (now - start > 10 * 1000) // 10ms
                    break;
            } else {
                start = getTime();
                ++count;
            }
        }
#ifdef DEBUG
        std::cout << "Clear buff " << count << " byte(s). " << std::endl;
#endif
    }

private:
    // block until receive a byte from serial port
    char receive() const {
        char buff[1];
        while (read(_com, buff, 1) <= 0);
        return buff[0];
    }
    
    uintmax_t getTime() const {
        struct timeval now;
        gettimeofday(&now, 0);
        return now.tv_sec + 1e6 * now.tv_usec;
    }
    
    // send a byte to serial port
    void send(const char x) {
        char buff[1];
        buff[0] = x;
        write(_com, buff, 1);
    }

    Communicator(const Communicator&) = delete;
    Communicator(Communicator&&) = delete;
    Communicator& operator=(const Communicator&) & = delete;
    Communicator& operator=(Communicator&&) & = delete;

    int _send_packet_size;
    int _recv_packet_size;
    int _com;
    std::unique_ptr<char[]> _buffer;
};

#endif /* COM_COMM_H_ */
