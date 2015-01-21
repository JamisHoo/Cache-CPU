#include <defs.h>
#include <stdio.h>
#include <ulib.h>

int _Alloc(int n) {
    return 0;
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

