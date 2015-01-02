#ifndef __LIBS_MIPS32S_H__
#define __LIBS_MIPS32S_H__

#include <defs.h>
#include <cp0.h>

#define do_div(n, base) ({                                      \
    unsigned __mod, q;                                          \
    if (base == 10) {                                           \
        q = (n >> 1) + (n >> 2);                                \
        q += q >> 4;                                            \
        q += q >> 8;                                            \
        q += q >> 16;                                           \
        q >>= 3;                                                \
        __mod = n - (((q << 2) + q) << 1);                      \
        q += ((__mod + 6) >> 4);                                \
        __mod = n - (((q << 2) + q) << 1);                      \
        n = q;                                                  \
    } else if (base == 16) {                                    \
        __mod = n & 0xf;                                        \
        n >>= 4;                                                \
    } else if (base == 8) {                                     \
        __mod = n & 0x7;                                        \
        n >>= 3;                                                \
    } else if (base == 2147483648UL) {                          \
        __mod = n & 0x7fffffff;                                 \
        n >>= 31;                                               \
    } else {                                                    \
        __mod = 3;                                              \
        n = 1;                                                  \
    }                                                           \
    __mod;                                                      \
 })

#define mfc0(reg) ({                                            \
    uint32_t var;                                               \
    asm volatile("mfc0 %0, " xstr(reg) : "=r" (var));           \
    var;                                                        \
 })
#define mtc0(reg, var) asm volatile("mtc0 %0, " xstr(reg) : : "r" (var))

static inline void tlbwi(void) __attribute__((always_inline));

static inline void
tlbwi(void) {
    asm volatile ("tlbwi");
}

#endif /* !__LIBS_MIPS32S_H__ */

