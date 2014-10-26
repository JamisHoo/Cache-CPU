#include <stdio.h>

#define N 1000
int p[N];

int
main(void) {
    int i;
    for (i = 2; i < N; ++i)
        p[i] = 1;
	int cnt = 0;
    for (i = 2; i < N; ++i)
        if (p[i]) {
			cnt ++;
            cprintf("%d ", i);
            int j;
            for (j = i + i; j < N; j += i)
                p[j] = 0;
        }
    cprintf("\nnr prime=%d\n", cnt);
    return 0;
}

