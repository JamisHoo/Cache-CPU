/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: 
 *  Filename: romgen.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 03, 2014
 *  Time: 14:32:10
 *  Description: 
 *****************************************************************************/
#include <iostream>
#include <fstream>

int main(int argc, char **argv) {
    using namespace std;
    
    if (argc != 3) {
        cout << "Usage: <binary file> <VHDL file>. " << endl;
        return 1;
    }

    ifstream fin(argv[1], ifstream::in | ifstream::binary);
    ofstream fout(argv[2], ofstream::out | ofstream::binary);

    fout << "case (rom_addr) is" << endl;
    char buff[4];
    int addr = 0;
    char buffer[1024];
    while (fin.read(buff, 4)) {
        swap(buff[0], buff[3]);
        swap(buff[1], buff[2]);
        sprintf(buffer, "    when %6d => rom_data <= X\"%08X\"; \n", addr, *(int*)(buff));
        // fout << "    when " << addr << " => rom_data <= X\"" << hex << *(unsigned*)(buff) << dec << "\"; \n";
        fout << string(buffer);
        addr += 4;
    }
    fout << "    when others => rom_data <= X\"BBBBBBBB\";" << endl;
    fout << "end case;" << endl;
}

