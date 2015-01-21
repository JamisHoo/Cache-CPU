#include <defs.h>
#include <mips32s.h>
#include <picirq.h>

// Current IRQ mask.
static uint8_t irq_mask = 0x00;
static bool did_init = 0;

static void
pic_setmask(uint8_t mask) {
    irq_mask = mask;
    if (did_init) {
        uint32_t status = mfc0(CP0_Status);
        status = (status & 0xffff00ff) | (mask << 8);
        mtc0(CP0_Status, status);
    }
}

void
pic_enable(unsigned int irq) {
    pic_setmask(irq_mask | (1 << irq));
}

/* pic_init - initialize interrupt fields in CP0_Status */
void
pic_init(void) {
    did_init = 1;

    mtc0(CP0_Status, 0x00000000);

    if (irq_mask != 0x00) {
        pic_setmask(irq_mask);
    }
}

