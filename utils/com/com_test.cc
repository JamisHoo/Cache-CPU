#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <iostream>
#include <fstream>

#define MODEM "/dev/ttyUSB0"
#define BAUDRATE B38400

int main(int argc,char** argv)
{   
    struct termios tio;
    int tty_fd, flags;
    unsigned char c='D';
    printf("Please start with %s /dev/ttyS1 (for example)\n",argv[0]);
    memset(&tio,0,sizeof(tio));
    tio.c_iflag=0;
    tio.c_oflag=0;
    tio.c_cflag=CS8|CREAD|CLOCAL;           // 8n1, see termios.h for more information
    tio.c_lflag=0;
    tio.c_cc[VMIN]=1;
    tio.c_cc[VTIME]=5;
    if((tty_fd = open(MODEM , O_RDWR | O_NONBLOCK)) == -1){
        printf("Error while opening\n"); // Just if you want user interface error control
        return -1;
    }
    cfsetospeed(&tio,BAUDRATE);    
    cfsetispeed(&tio,BAUDRATE);            // baudrate is declarated above
    tcsetattr(tty_fd,TCSANOW,&tio);

    std::cout << "Prepare to send. " << std::endl;
    std::ifstream fin("send", std::ifstream::in | std::ifstream::binary);
    std::ofstream fout("receive", std::ofstream::out | std::ofstream::binary);
    
    char buff[1];
    while (fin.read(buff, 1)) {
        write(tty_fd, buff, 1);

        // waiting for the response
        while (read(tty_fd, buff, 1) <= 0);
            fout.write(buff, 1);
        while (read(tty_fd, buff, 1) <= 0);
            fout.write(buff, 1);
        // sleep(1);
    }

    close(tty_fd);
    return 0;
}
