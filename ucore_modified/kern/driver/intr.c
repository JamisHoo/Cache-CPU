#include <mips32s.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
    uint32_t status = mfc0(CP0_Status);
    mtc0(CP0_Status, status | 0x00000001);
}

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
    uint32_t status = mfc0(CP0_Status);
    mtc0(CP0_Status, status & 0xfffffffe);
}

