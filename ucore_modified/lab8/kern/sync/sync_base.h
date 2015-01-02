#ifndef __KERN_SYNC_SYNC_BASE_H__
#define __KERN_SYNC_SYNC_BASE_H__

#include <defs.h>
#include <mips32s.h>
#include <intr.h>

static inline bool
__intr_save(void) {
    if (mfc0(CP0_Status) & 0x00000001) {
        intr_disable();
        return 1;
    }
    return 0;
}

static inline void
__intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

#define local_intr_save(x)      do { x = __intr_save(); } while (0)
#define local_intr_restore(x)   __intr_restore(x);

#endif /* !__KERN_SYNC_SYNC_BASE_H__ */

