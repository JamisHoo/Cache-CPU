#include <mips32s.h>
#include <stdlib.h>

static unsigned long long next = 1;

/* *
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
    /*
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
    unsigned long long result = (next >> 12);
    return (int)do_div(result, RAND_MAX + 1);
    */
    next = (unsigned long)next * 1103515245 + 12345;
    return ((unsigned long)next % (RAND_MAX+1));
}

/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
    next = seed;
}

