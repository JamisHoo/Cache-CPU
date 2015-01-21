#ifndef __LIBS_ATOMIC_H__
#define __LIBS_ATOMIC_H__

#include <sync_base.h>

/* Atomic operations that C can't guarantee us. Useful for resource counting etc.. */

static inline void set_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline void clear_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline void change_bit(int nr, volatile void *addr) __attribute__((always_inline));
static inline bool test_bit(int nr, volatile void *addr) __attribute__((always_inline));

/* *
 * set_bit - Atomically set a bit in memory
 * @nr:     the bit to set
 * @addr:   the address to start counting from
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        *(volatile long *)addr |= (1 << nr);
    }
    local_intr_restore(intr_flag);
}

/* *
 * clear_bit - Atomically clears a bit in memory
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        *(volatile long *)addr &= ~(1 << nr);
    }
    local_intr_restore(intr_flag);
}

/* *
 * change_bit - Atomically toggle a bit in memory
 * @nr:     the bit to change
 * @addr:   the address to start counting from
 * */
static inline void
change_bit(int nr, volatile void *addr) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        *(volatile long *)addr ^= (1 << nr);
    }
    local_intr_restore(intr_flag);
}

/* *
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        oldbit = (*(volatile long *)addr) & (1 << nr);
    }
    local_intr_restore(intr_flag);
    return oldbit != 0;
}

/* *
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
    int oldbit;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        oldbit = (*(volatile long *)addr) & (1 << nr);
        *(volatile long *)addr |= (1 << nr);
    }
    local_intr_restore(intr_flag);
    return oldbit != 0;
}

/* *
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
    int oldbit;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        oldbit = (*(volatile long *)addr) & (1 << nr);
        *(volatile long *)addr &= ~(1 << nr);
    }
    local_intr_restore(intr_flag);
    return oldbit != 0;
}
#endif /* !__LIBS_ATOMIC_H__ */

