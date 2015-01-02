#include <defs.h>
int divmod(int a, int b, int* q_store, int* r_store)
{
    if (b == 0)
        return -1;
    int sign_div = 1, sign_mod = 1;
    if (a < 0) {
        sign_div = -sign_div;
        sign_mod = -1;
        a = -a;
    }
    if (b < 0) {
        sign_div = -sign_div;
        b = -b;
    }
    int r = 0, q = 0, i;
    for (i = 0; i < 32; i++) {
        r = (r<<1) | ((a>>31) & 1);
        a = a<<1;
        q = q<<1;
        if (r >= b) {
            q = q | 1;
            r = r - b;
        }
    }
    *q_store = q;
    if (sign_div == -1)
        *q_store = -q;
    *r_store = r;
    if (sign_mod == -1)
        *r_store = -r;
    return 0;
}

