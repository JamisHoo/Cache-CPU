#include <ulib.h>
#include <stdio.h>

const int max_child = 3;

int
main(void) {
    int n, pid, k;
    for (n = 0; n < max_child; n ++) {
        if ((pid = fork()) == 0) {
			for (k = 0; k < 10; k ++)
				cprintf("I am child %d: %d\n", n, k);
            exit(0);
        }
        assert(pid > 0);
    }

    if (n > max_child) {
        panic("fork claimed to work %d times!\n", n);
    }

    for (; n > 0; n --) {
        if (wait() != 0) {
            panic("wait stopped early\n");
        }
    }

    if (wait() == 0) {
        panic("wait got too many\n");
    }

    cprintf("forktest pass.\n");
    return 0;
}

