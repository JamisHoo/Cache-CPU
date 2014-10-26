#ifndef __KERN_DRIVER_CLOCK_H__
#define __KERN_DRIVER_CLOCK_H__

#include <defs.h>

extern volatile size_t ticks;
extern volatile uint32_t next_compare_val;

void clock_init(void);

#endif /* !__KERN_DRIVER_CLOCK_H__ */

