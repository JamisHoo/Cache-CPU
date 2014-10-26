/*
 * $File: userlib.c
 * $Date: Sat Dec 21 21:44:37 2013 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */

#include <stdio.h>
#include <ulib.h>
#include <readline.h>
#include <thumips.h>

#define MEM_BUF_SIZE	1024
void* Alloc(int size) {
	static char buf[MEM_BUF_SIZE];
	static int cur_size;
	char *ret = buf + cur_size;
	size += (4 - (size & 3)) & 3;
	cur_size += size;
	if (cur_size > MEM_BUF_SIZE) {
		cprintf("full of memory\n");
		exit(0);
	}
	return ret;
}

void PrintString(const char *str) {
	while (*str)
		sys_putc(*(str ++));
}

void PrintInt(int val) {
	if (!val) {
		sys_putc('0');
		return;
	}
	if (val < 0) {
		sys_putc('-');
		val = -val;
	}
	static char buf[20];
	char *ptr = buf + 19;
	while (val) {
      int div = __divu10(val),
		  mod = val - __mulu10(div);
	  *(-- ptr) = mod + '0';
	  val = div;
	}
	PrintString(ptr);
}

int _ReadInteger() {
	char *str = readline(NULL);
	int rst = 0;
	while (*str) {
		rst = (rst << 3) + (rst << 1) + (*str - '0');
		str ++;
	}
	return rst;
}

