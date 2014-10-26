#ifndef __LIBS_STDIO_H__
#define __LIBS_STDIO_H__

#include <defs.h>
#include <stdarg.h>

/* kern/libs/stdio.c */
int vkprintf(const char *fmt, va_list ap);
int kprintf(const char *fmt, ...);
void kputchar(int c);
int kputs(const char *str);
int getchar(void);

void printhex(unsigned int x);
void printbase10(int x);

/* kern/libs/readline.c */
char *readline(const char *prompt);

#define PRINT_HEX(str,x) {kprintf(str);printhex((unsigned int)x);kprintf("\n");}


// add by Xinyu Zhou
/**
 * dprintf: debug printf, print when __DEBUG is 1
 */
#define dprintf(...) do { if (__DEBUG) { kprintf("[kernel mode] %s: ", __func__); kprintf(__VA_ARGS__); } } while (0)
#endif /* !__LIBS_STDIO_H__ */


