#include <stdio.h>
#include <ulib.h>

#define N 1000
int p[N];

int
main(void) {
    int i;
    for (i = 2; i < N; ++i)
        p[i] = 1;
    for (i = 2; i < N; ++i)
        if (p[i]) {
            cprintf("%d is a prime number\n", i);
            int j;
            for (j = i + i; j < N; j += i)
                p[j] = 0;
        }
    cprintf("prime pass.\n");
    return 0;
}

