/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu 
 *  Distributed under the MIT license 
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *  
 *  Project: 
 *  Filename: verify.cc 
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Nov. 12, 2014
 *  Time: 10:30:18
 *  Description: 
 *****************************************************************************/
#include <iostream>
#include <fstream>
#include <sstream>
#include <cassert>
#include <cstring>
#include <string>

int main() {
    using namespace std;
    ifstream fin_send("send", fstream::in | fstream::binary);
    ifstream fin_recv("receive", fstream::in | fstream::binary);
    
    // string send_str(istreambuf_iterator<char>(fin_send),
    //           istreambuf_iterator<char>());
    string send_str, recv_str;
    send_str.assign(istreambuf_iterator<char>(fin_send), 
                    istreambuf_iterator<char>());

    recv_str.assign(istreambuf_iterator<char>(fin_recv),
                    istreambuf_iterator<char>());

    assert(send_str.length() == recv_str.length());
    
    int wrong = 0;
    for (int i = 0; i < send_str.length(); ++i) 
        if (char(send_str[i]) != char(recv_str[i] - 1)) {
            ++wrong;
            cout << char(send_str[i]) << ' ' << char(recv_str[i] - 1) << endl;
        }

    cout << wrong << endl;
}
