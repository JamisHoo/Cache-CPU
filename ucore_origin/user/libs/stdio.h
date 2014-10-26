#ifndef __LIBS_STDIO_H__
#define __LIBS_STDIO_H__

#include <defs.h>
#include <stdarg.h>

/* kern/libs/stdio.c */
int vcprintf(const char *fmt, va_list ap);
int cprintf(const char *fmt, ...);
void cputchar(int c);
int getchar(void);

void printhex(unsigned int x);
void printbase10(int x);


// add by Xinyu Zhou
/**
 * dprintf: debug printf, print when __DEBUG is 1
 */
#define dprintf(...) do { if (__DEBUG) fprintf(1, __VA_ARGS__); } while (0)

#endif /* !__LIBS_STDIO_H__ */


