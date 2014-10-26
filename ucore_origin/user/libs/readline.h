/*
 * $File: readline.h
 * $Date: Thu Dec 19 11:05:14 2013 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */

#include <syscall.h>
#include <ulib.h>
#include <file.h>

static inline char *readline(const char *prompt) {
    static char buffer[512];
    if (prompt != NULL) {
        fprintf(1, "%s", prompt);
    }
    int ret, i = 0;
    while (1) {
        char c;
        if ((ret = read(0, &c, sizeof(char))) < 0) {
            return NULL;
        }
        else if (ret == 0) {
            if (i > 0) {
                buffer[i] = '\0';
                break;
            }
            return NULL;
        }

        if (c == 3) {
            return NULL;
        }
        else if (c >= ' ' && i < sizeof(buffer) - 1) {
            sys_putc(c);
            buffer[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
            sys_putc(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
            sys_putc(c);
            buffer[i] = '\0';
            break;
        }
    }
    return buffer;
}
