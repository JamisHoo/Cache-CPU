#include <defs.h>
#include <stdio.h>
#include <ulib.h>
#include <file.h>

/* added by Jamis Hoo */
int _Div(int x, int y) {
    int quotient = 0;
    int remainder = 0;
    int xx = x > 0? x: -x;
    int yy = y > 0? y: -y;
    int i;
    for (i = 8 * sizeof(int) - 1; i >= 0; --i) {
        remainder <<= 1;
        remainder |= xx >> i & 1;
        if (remainder >= yy)
            remainder -= yy, quotient |= 1 << i;
    }
    return ((x > 0 && y > 0) || (x < 0 && y < 0))? quotient: -quotient;
}

/* added by Jamis Hoo */
int _Rem(int x, int y) {
    int quotient = 0;
    int remainder = 0;
    int xx = x > 0? x: -x;
    int yy = y > 0? y: -y;
    int i;
    for (i = 8 * sizeof(int) - 1; i >= 0; --i) {
        remainder <<= 1;
        remainder |= xx >> i & 1;
        if (remainder >= yy)
            remainder -= yy, quotient |= 1 << i;
    }
    return x > 0? remainder: -remainder;
}

void _PrintInt(int x) {
    cprintf("%d", x);
}
void _PrintChar(char x) {
    cprintf("%c", x);
}
void _PrintString(const char* x) {
    cprintf("%s", x);
}
void _PrintBool(bool x) {
    if (x)
        cprintf("true");
    else
        cprintf("false");
}
void __noreturn _Halt(void) {
    exit(0);
}

/* modified by Jasmis Hoo */
#define BUFSIZE 4096
char* _ReadLine(const char *prompt) {
    static char buffer[BUFSIZE];
    if (prompt != NULL) {
        cprintf("%s", prompt);
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
        else if (c >= ' ' && i < BUFSIZE - 1) {
            cprintf("%c", c);
            buffer[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
            cprintf("%c", c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
            cprintf("%c", c);
            buffer[i] = '\0';
            break;
        }
    }
    return buffer;
}

// original author is Kai Jia
int _ReadInteger() {
	char *str = _ReadLine(NULL);
	int rst = 0;
	while (*str) {
		rst = (rst << 3) + (rst << 1) + (*str - '0');
		str ++;
	}
	return rst;
}

// original author is Kai Jia
// modified by Jamis Hoo
#define MEM_BUF_SIZE	4096
void* _Alloc(int size) {
	static char buf[MEM_BUF_SIZE];
	static int cur_size = 0;
	char *ret = buf + cur_size;
	size += (4 - (size & 3)) & 3;
	cur_size += size;
	if (cur_size > MEM_BUF_SIZE) {
		cprintf("full of memory\n");
		exit(0);
	}
	return ret;
}
