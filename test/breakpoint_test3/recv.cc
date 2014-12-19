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
#include <cstdio>
#include <fstream>

typedef unsigned char uint8_t;

const char* MODEM = "/dev/ttyUSB0";

uint8_t receive(const int com) {
    char buff[1];
    while (read(com, buff, 1) <= 0);
    return buff[0];
}
void show(unsigned int *data,int n);

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
    int n = 512;
    char *datas = new char[n];
    unsigned int* datas_i = new unsigned int[n/2];
    while (1) {
        datas[count] = receive(com) & 0xff;
        if (++count == n)
        {
            count = 0;
            for (int i=0;i<n/2;i++)
            {
                datas_i[i]=0;
                for (int j=0;j<2;j++)
                {
                    int temp = (int)datas[i*2+j];
                    if (temp<0)
                        temp += 256;
                    datas_i[i] = datas_i[i] * 256 + temp;
                }
            }
            show(datas_i,n/2);
        }
    }
    delete []datas;

    close(com);
    return 0;
}

unsigned getbits(unsigned int in_data, int left, int right)
{
    if (left >= right)
        return (((in_data) >> (right)) % (1 << (left-right+1)));
    else
        return 0;
}
unsigned getbit(unsigned int in_data, int addr)
{
    return ((in_data >> (addr)) % 2);
}
void show_16bits(unsigned int data)
{
    unsigned int compare = 1 << 15;
    for (int i=0;i<16;i++)
    {
        if ((data & compare) != 0)
            std::cout << '1';
        else
            std::cout << '0';
        compare = compare / 2;
    }
}

std::string change_16bits_to_2(unsigned int data)
{
    unsigned int compare = 1 << 15;
    std::string value = "";
    for (int i=0;i<16;i++)
    {
        if ((data & compare) != 0)
            value = value + "1";
        else
            value = value + "0";
        compare = compare / 2;
    }
    return value;
}

void show(unsigned int *data, int n)
{
    std::ofstream fout("recv.txt");
    for (int i=0;i<n;i++)
    {
        fout << change_16bits_to_2(data[i]);
        if (i % 4 == 3)
            fout << '\n';
        else
            fout << '\t';
        if ((i+1) % (n/4) ==0)
            fout << '\n';
    }
    fout.close();

    std::cout << std::endl;
    {
        std::string state_label[8];
        state_label[0] = "Instruction Fetch";
        state_label[1] = "Instruction Decode";
        state_label[2] = "Execute";
        state_label[3] = "Memory Access";
        state_label[4] = "Memory Access for storing bit";
        state_label[5] = "Write Back";
        state_label[6] = "Exception";
        state_label[7] = "None";
        std::cout << "Next State: " << state_label[getbits(data[0],15,13)] << std::endl;
        std::cout << "Last State: " << state_label[getbits(data[0],12,10)] << std::endl;
        std::cout << "Normal Next State: " << state_label[getbits(data[0],9,7)] << std::endl;
        if (getbit(data[1],15) == 1)
        {
            std::cout << "Exception happens" << std::endl;
            if (getbit(data[1],13) == 1)
                std::cout << "Clock Interrupt happens" << std::endl;
            if (getbit(data[1],12) == 1)
                std::cout << "Serial Interrupt happens" << std::endl;
            if (getbit(data[1],9) == 1)
                std::cout << "Clock Interrupt exists" << std::endl;
            if (getbit(data[1],10) == 1)
                std::cout << "Serial Interrupt exists" << std::endl;
            if (getbits(data[1],7,6) == 1)
                std::cout << "System Call" << std::endl;
            else if (getbits(data[1],7,6) == 2)
                std::cout << "Instruction Not Recognized" << std::endl;
            switch (getbits(data[1],5,3))
            {
                case 1:
                    std::cout << "TLB_MODIFIED Exception" << std::endl;
                    break;
                case 2:
                    std::cout << "TLB miss when loading Exception" << std::endl;
                    break;
                case 3:
                    std::cout << "TLB miss when storing Exception" << std::endl;
                    break;
                case 4:
                    std::cout << "Unaligened Memory Access when loading Exception" << std::endl;
                    break;
                case 5:
                    std::cout << "Unaligened Memory Access when storing Exception" << std::endl;
                    break;
                default:
                    break;
            }
        }
        else if (getbit(data[1],14) == 0)
            std::cout << "MMU not ready" << std::endl;
    }
    {
        std::cout << "PC now: " << (data[2] << 16)+data[3] << ' ';
        show_16bits(data[2]);
        show_16bits(data[3]);
        std::cout << std::endl;
        std::cout << "PC for MMU: " << (data[4] << 16) + data[5] << ' ';
        show_16bits(data[4]);
        show_16bits(data[5]);
        std::cout << std::endl;
        if (getbit(data[0],2) == 1)
            std::cout << "ERET, EPC: " << (data[8] << 16) + data[9] << std::endl;
        else if (getbit(data[0],1) == 1)
            std::cout << "Exception, EBase: " << (data[10] << 16) + data[11] << std::endl;
        else
            std::cout << "Normal PC: " << (data[6] << 16) + data[7] << std::endl;
        std::cout << "Instruction now: " << (data[12] << 16) + data[13] << ' ';
        show_16bits(data[12]);
        show_16bits(data[13]);
        std::cout << std::endl;
    }

    {
        std::cout << "Rs address: " << getbits(data[14],15,11) << std::endl;
        std::cout << "Rs value: " << (data[18] << 16) + data[19] << ' ';
        show_16bits(data[18]);
        show_16bits(data[19]);
        std::cout << std::endl;
        std::cout << "Rt address: " << getbits(data[14],10,6) << std::endl;
        std::cout << "Rt value: " << (data[20] << 16) + data[21] << ' ';
        show_16bits(data[20]);
        show_16bits(data[21]);
        std::cout << std::endl;
        std::cout << "Rd address: " << getbits(data[14],5,1) << std::endl;
    }
    if (getbits(data[0],15,13) == 2)
    {
        std::cout << "Operand A: ";
        switch(getbits(data[15],10,9))
        {
            case 0:
                std::cout << "Rs value";
                break;
            case 1:
                std::cout << "Immediate number";
                break;
            case 2:
                std::cout << "value from CP0";
                break;
            case 3:
                std::cout << "16";
                break;
            default:
                break;
        }
        std::cout << std::endl << "Operand B: ";
        switch (getbits(data[15],8,7))
        {
            case 0:
                std::cout << "Rt value";
                break;
            case 1:
                std::cout << "Immediate number";
                break;
            case 2:
                std::cout << "0";
                break;
            case 3:
                std::cout << "None";
                break;
            default:
                break;
        }
        std::cout << std::endl << "Operator: ";
        switch (getbits(data[15],6,2))
        {
            default:
                std::cout << getbits(data[15],6,2);
                break;
        }
        std::cout << std::endl;
    }
    std::cout << "ALU result: " << (data[22] << 16) + data[23] << ' ';
    show_16bits(data[22]);
    show_16bits(data[23]);
    std::cout << std::endl;
    std::cout << "Immediate number: " << (data[16] << 16) + data[17] << ' ';
    show_16bits(data[16]);
    show_16bits(data[17]);
    std::cout << std::endl;
    if (getbit(data[31],10) == 1)
    {
        std::cout << "Write Back to general registers" << std::endl;
        std::cout << "Address: " << getbits(data[31],15,11) << std::endl;
        std::cout << "Value: " << (data[32] << 16) + data[33] << ' ';
        show_16bits(data[32]);
        show_16bits(data[33]);
        std::cout << std::endl;
    }
    show_16bits(data[60]);
    show_16bits(data[61]);
    std::cout << std::endl;
    show_16bits(data[30]);
    std::cout << std::endl;
}
