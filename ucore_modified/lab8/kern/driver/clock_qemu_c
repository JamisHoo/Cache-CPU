#include <clock.h>
#include <mips32s.h>
#include <trap.h>
#include <stdio.h>
#include <picirq.h>

#define TIMER_DELTA     0x100000

volatile size_t ticks;

/* *
 * clock_init - initialize MIPS timer to interrupt,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
    // set MIPS timer, function name is a little confusing
    clock_intr();

    // initialize time counter 'ticks' to zero
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
    pic_enable(IRQ_TIMER);
}

void
clock_intr(void) {
    uint32_t count = mfc0(CP0_Count);
    mtc0(CP0_Compare, count + TIMER_DELTA);
}
