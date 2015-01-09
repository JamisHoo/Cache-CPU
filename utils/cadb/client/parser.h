/******************************************************************************
 *  Copyright (c) 2014 Jamis Hoo 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: 
 *  Filename: parser.h 
 *  Version: 1.0
 *  Author: Jamis Hoo
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 31, 2014
 *  Time: 21:51:51
 *  Description: 
 *****************************************************************************/
#ifndef PARSER_H_
#define PARSER_H_

#include <iostream>
#include <fstream>
#include <vector>
#include <unordered_map>
#include "com_comm.h"
#include "config.h"

class Parser {
    static constexpr int CMD_LENGTH = 17;
    static constexpr int MSG_LENGTH = 512;

    static constexpr char* HELP_INFO = (char*)(
        "run                    : start running. \n"
        "break <address>        : set breakpoint at <address>, globbing('_') is supported. \n"
        "continue               : continue running. \n"
        "step [n]               : run n clocks, n is default 1. \n"
        "print[b|x] <label>     : print value of <label> in binary or hexadecimal(default). \n"
        "display[b|x] <label>   : automatically print value of <label> each time program stops. \n"
        "undisplay <label>      : remove item <label> from auto-display list. \n"
        "help                   : print usage infomation of Cache Debugger. \n"
        "quit                   : quit. \n"
    );
public:

    Parser(std::ostream& out, const char* vhdl_var_name, const int vhdl_var_size):
        _out(out), _comm(CMD_LENGTH, MSG_LENGTH), _config(vhdl_var_name, vhdl_var_size) {
        _out << "Loading configuration... " << std::endl;
        if (_config.load()) 
            _out << "Load configuration failed. " << std::endl;
        else 
            _out << "Load configuration successful. " << std::endl;
    }

    bool open(const char* dev) {
        if (_comm.open(dev, 0)) 
            return 1; 
            
        _comm.clearSystemBuff();
        
        return 0;
    }

    std::string getVHDLCode() const {
        return _config.vhdlCode();
    }

    // assert str is trimmed
    bool parse(const std::string& str) {
        if (str == "help") {
            _out << HELP_INFO << std::endl;
        } else if (str == "run") {
            run();
        } else if (str.substr(0, 5) == "break") {
            return setBreak(str.substr(5));
        } else if (str == "continue") {
            continueRun();
        } else if (str.substr(0, 4) == "step") {
            return stepClock(trim(str.substr(4)));
        } else if (str.substr(0, 5) == "print") {
            switch (str[5]) {
                case 'x':
                    return print(16, trim(str.substr(6)));
                case 'b':
                    return print(2, trim(str.substr(6)));
                case ' ':
                    return print(16, trim(str.substr(5)));
                default:
                    _out << "Invalid base. " << std::endl;
                    return 1;
            }
        } else if (str.substr(0, 7) == "display") {
            switch (str[7]) {
                case 'x':
                    return display(16, trim(str.substr(8)));
                case 'b':
                    return display(2, trim(str.substr(8)));
                case ' ':
                    return display(16, trim(str.substr(8)));
                default:
                    _out << "Invalid base. " << std::endl;
                    return 1;
            }
        } else if (str.substr(0, 9) == "undisplay") {
            undisplay(trim(str.substr(9)));
            return 0;
        } else {
            _out << "Invalid command. " << std::endl;
            return 1;
        }
        return 0;
    }

private:
    std::string trim(std::string str) const {
        str.erase(0, str.find_first_not_of(" \n\t\r")); 
        str.erase(str.find_last_not_of(" \n\t\r") + 1);
        return str;
    }
    // get base from number literal
    // only binary and decimal and hexadecimal are supported
    int getBase(const std::string& str, const std::string& wildcard = "") const {
        if (str.length() >= 2 && str[0] == '0' && (str[1] == 'x' || str[1] == 'X')) {
            if (str.find_first_not_of(wildcard + "x0123456789ABCDEFabcdef") != std::string::npos)
                return -1;
            else 
                return 16;
        }
        if (str.length() >= 2 && str[0] == '0' && (str[1] == 'b' || str[1] == 'B')) {
            if (str.find_first_not_of(wildcard + "b01") != std::string::npos)
                return -1;
            else 
                return 2;
        }
        if (str.find_first_not_of("1234567890") != std::string::npos) 
            return -1;
        return  10;
    }
    // for breakpoint address
    uint64_t getMask(std::string str, const int base) const {
        assert(base == 2 || base == 16);
        char mask = base == 2? '1': 'f';
        for (auto& c: str) 
            if (c == '_') c = mask;
            else c = '0';
        return ~stoull(str, nullptr, base);
    }
    void run() {
        // construct command
        std::string command(CMD_LENGTH, '\x00');
        command[0] = '\x01';
        _comm.clearSystemBuff();
        // send command
        _comm.send(command);
        // wait for message
        _buff = _comm.recv();
        displayAll();
    }
    bool setBreak(const std::string& address) {
        std::string addr = trim(address);

        // get base and check validation
        int base = getBase(addr, "_"); 
        // invalid 
        if (base == -1 || base == 10) {
            _out << "Invalid address. " << std::endl;
            return 1;
        }
        uint64_t mask = getMask(addr, base);
        // convert address from literal to machine data
        replace(addr.begin(), addr.end(), '_', '0');
        uint64_t x = stoull(addr.substr(2), nullptr, base);

        std::string command(CMD_LENGTH, '\x00');
        command[0] = '\x02';
        command[1] = x & 0xff;
        command[2] = x >> 8 & 0xff;
        command[3] = x >> 16 & 0xff;
        command[4] = x >> 24 & 0xff;
        command[5] = x >> 32 & 0xff;
        command[6] = x >> 40 & 0xff;
        command[7] = x >> 48 & 0xff;
        command[8] = x >> 56 & 0xff;
        command[9] = mask & 0xff;
        command[10] = mask >> 8 & 0xff;
        command[11] = mask >> 16 & 0xff;
        command[12] = mask >> 24 & 0xff;
        command[13] = mask >> 32 & 0xff;
        command[14] = mask >> 40 & 0xff;
        command[15] = mask >> 48 & 0xff;
        command[16] = mask >> 56 & 0xff;
        _comm.send(command);
        return 0;
    }
    void continueRun() {
        std::string command(CMD_LENGTH, '\x00');
        command[0] = '\x03';
        _comm.send(command);
        _buff = _comm.recv();
        displayAll();
    }
    bool stepClock(const std::string& n) {
        std::string num = trim(n);
        // step 1 clock by default
        if (!num.length()) num = "0x01";
        
        // get base and check validation
        int base = getBase(num); 
        // invalid 
        if (base == -1) {
            _out << "Invalid address. " << std::endl;
            return 1;
        }
        // convert address from literal to machine data

        uint64_t x = stoull(base == 10? num: num.substr(2), nullptr, base);

        std::string command(CMD_LENGTH, '\x00');
        command[0] = '\x04';
        command[1] = x & 0xff;
        command[2] = x >> 8 & 0xff;
        command[3] = x >> 16 & 0xff;
        command[4] = x >> 24 & 0xff;
        command[5] = x >> 32 & 0xff;
        command[6] = x >> 40 & 0xff;
        command[7] = x >> 48 & 0xff;
        command[8] = x >> 56 & 0xff;
        _comm.send(command);
        _buff = _comm.recv();
        displayAll();
        return 0;
    }
    bool print(const int base, const std::string& name) const {
        auto range = _config.range(name);
        if (range.first < 0 || range.second < 0) {
            _out << "Invalid variable name. " << std::endl;
            return 1;
        }
        int ub = range.first;
        int lb = range.second;
        assert(lb % 8 == 0);

        if (base == 2) {
            _out << name << " = 0b";
            for (int i = ub ; i >= lb; --i)
                _out << bool(_buff[i / 8] & 0x01 << i % 8);
        } else if (base == 16) {
            _out << name << " = 0x" << std::hex;
            for (int i = ub / 8; i >= lb / 8; --i)
                _out << ((unsigned char)(_buff[i]) < 16? "0": "")
                     << ((unsigned int)(_buff[i]) & 0xff);
            _out << std::dec;
        } else assert(0);
        _out << std::endl;
        return 0;
    }
    bool display(const int base, const std::string& name) {
        bool rtv = print(base, name);
        if (rtv == 1) return rtv;
        
        _display.push_back(std::make_pair(base, name));
        return 0;
    }
    void undisplay(const std::string& name) {
        for (intmax_t i = intmax_t(_display.size()) - 1; i >= 0; --i)
            if (_display[i].second == name)
                _display.erase(_display.begin() + i);
    }
    void displayAll() const {
        for (const auto& d: _display)
            print(d.first, d.second);
    }

    std::ostream& _out;
    Communicator _comm;
    std::string _buff;
    Config _config;
    std::vector< std::pair<int, std::string> > _display;
};

#endif /* PARSER_H_ */
