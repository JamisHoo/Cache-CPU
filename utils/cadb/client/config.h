/******************************************************************************
 *  Copyright (c) 2015 Jamis Hoo 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: 
 *  Filename: config.h 
 *  Version: 1.0
 *  Author: Jamis Hoo
 *  E-mail: hjm211324@gmail.com
 *  Date: Jan. 03, 2015
 *  Time: 11:53:35
 *  Description: 
 *****************************************************************************/
#ifndef CONFIG_H_
#define CONFIG_H_

#include <string>
#include <cstring>
#include <memory>
#include <fstream>
#include <unordered_map>
#include <vector>
#include <tuple>

class Config {
    static constexpr char* CONFIG_FILE = (char*)("cadb.cfg");
    static constexpr int CONFIG_VARNAME_MAX_LENGTH = 1024;
public: 
    Config(const std::string& vn, const int vs): 
        _vhdl_var_name(vn), _vhdl_var_size(vs) { }

    std::pair<int, int> range(const std::string& label) const {
        auto ite = _range.find(label);
        if (ite == _range.end()) return std::make_pair(-1, -1);
        return ite->second;
    }
    
    bool load() {
        std::ifstream fin(CONFIG_FILE);
        
        std::string str;
        int count = 0;
        while (getline(fin, str)) {
            str = trim(str);
            str = str.substr(0, str.find_first_of('#'));
            if (!str.length()) continue;


            char label[CONFIG_VARNAME_MAX_LENGTH];
            char vhdl_name[CONFIG_VARNAME_MAX_LENGTH];
            int vhdl_ub = -1, vhdl_lb = -1;
            int match_num = sscanf(str.c_str(), "%s %s (%d downto %d)", label, vhdl_name, &vhdl_ub, &vhdl_lb);

            if (match_num != 2 && match_num != 4) {
                return 1;
            }

            int index_ub = count + vhdl_ub - vhdl_lb;
            int index_lb = count;
            count = index_ub + 8 - index_ub % 8;
            _format.push_back(std::make_tuple(label, index_ub, index_lb));
            _range[label] = std::make_pair(index_ub, index_lb);
            
            _vars.push_back(std::make_tuple(label, vhdl_name, vhdl_ub, vhdl_lb));
        }
        return 0;
    }

    std::string vhdlCode() const {
        std::string code;
        int count = 0;
        std::unique_ptr<char[]> buff(new char[CONFIG_VARNAME_MAX_LENGTH * 4]);
        for (const auto& v: _vars) {
            // cout << get<0>(v) << ' ' << get<1>(v) << ' ' << get<2>(v) << ' ' << get<3>(v) << endl;
            std::string label, vhdl_name;
            int vhdl_ub, vhdl_lb;
            tie(label, vhdl_name, vhdl_ub, vhdl_lb) = v;
            int index_ub = count + vhdl_ub - vhdl_lb;
            int index_lb = count;

            memset(buff.get(), 0x00, CONFIG_VARNAME_MAX_LENGTH * 4);
            // std_logic
            if (vhdl_ub == -1) {
                assert(index_ub = index_lb);
                sprintf(buff.get(), "%s(%d) <= %s;\n",
                       _vhdl_var_name.c_str(), index_ub, vhdl_name.c_str());
            // std_logic_vector
            } else
                sprintf(buff.get(), "%s(%d downto %d) <= %s(%d downto %d);\n", 
                       _vhdl_var_name.c_str(), index_ub, index_lb, vhdl_name.c_str(), vhdl_ub, vhdl_lb);

            code += buff.get(); 
            memset(buff.get(), 0x00, CONFIG_VARNAME_MAX_LENGTH * 4);

            // others '0'
            if ((index_ub + 1) % 8)
                sprintf(buff.get(), "%s(%d downto %d) <= (others => '0');\n",
                       _vhdl_var_name.c_str(), index_ub + 7 - (vhdl_ub - vhdl_lb ) % 8, index_ub + 1);
            code += buff.get();

            count = index_ub + 8 - index_ub % 8;
        }
        memset(buff.get(), 0x00, CONFIG_VARNAME_MAX_LENGTH * 4);
        // others '0'
        if (count < _vhdl_var_size - 1)
            sprintf(buff.get(), "%s(%d downto %d) <= (others => '0');\n", 
                    _vhdl_var_name.c_str(), _vhdl_var_size - 1, count);
        code += buff.get();
    
        return code;
    }

private:
    std::string trim(std::string str) const {
        str.erase(0, str.find_first_not_of(" \n\t\r")); 
        str.erase(str.find_last_not_of(" \n\t\r") + 1);
        return str;
    }

    const std::string _vhdl_var_name;
    const int _vhdl_var_size; // in bits
    std::vector< std::tuple<std::string, std::string, int, int> > _vars;
    std::vector< std::tuple<std::string, int, int> > _format;
    std::unordered_map< std::string, std::pair<int, int> > _range;
};

#endif /* CONFIG_H_ */

