/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: Cache Debugger
 *  Filename: chedan.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 16, 2014
 *  Time: 19:03:47
 *  Description: compile with -lpthread to enable multithread
 *****************************************************************************/
#include <iostream>
#include <fstream>
#include "parser.h"


static constexpr char* VHDL_VAR_NAME = (char*)("out_datas");
static constexpr int VHDL_VAR_SIZE = 4096; // in bits

int main(int argc, char** argv) {   
    if (argc == 3 && std::string(argv[1]) == "gen") {
        std::ofstream fout(argv[2]);
        Parser parser(std::cout, VHDL_VAR_NAME, VHDL_VAR_SIZE);
        fout << parser.getVHDLCode() << std::endl;
        return 0;
    }
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " gen <vhdl file>. " << std::endl;
        std::cerr << "       " << argv[0] << " <serial port>. " << std::endl;
        return 1;
    }
    if (getuid()) {
        std::cerr << "Need root privilage. " << std::endl;
        return 1;
    }

    std::clog << "Welcome to Cache Debugger(Version 1.0). " << std::endl << std::endl;
    std::clog << "Commands end with enter. " << std::endl << std::endl;
    std::clog << "Type 'help' for help. Type Ctrl + D or 'quit' to quit. " << std::endl << std::endl;
    std::clog << "Copyright (c) 2014 Jamis Hoo, Terran Lee, Hao Sun. " << std::endl << std::endl;
    std::clog << "Distributed under the MIT LICENSE. " << std::endl << std::endl;

    Parser parser(std::cout, VHDL_VAR_NAME, VHDL_VAR_SIZE);


    // open serial port
    if (parser.open(argv[1])) {
        std::cerr << "Open serial port failed. " << std::endl;
        return 1;
    }

    std::string str;
    std::string old;
    while (true) {
        std::clog <<  "\033[1;31mcadb> \033[0m" << std::flush;
        if (!getline(std::cin, str)) break;

        // trim
        str.erase(0, str.find_first_not_of(" \n\t\r")); 
        str.erase(str.find_last_not_of(" \n\t\r") + 1);

        if (!str.length()) str = old;

        if (str == "quit") break;
        old = str;

        parser.parse(str);
    }
    std::clog << "Bye! " << std::endl;
    return 0;

}

