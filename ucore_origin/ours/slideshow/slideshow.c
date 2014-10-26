/*
 * $File: slideshow.c
 * $Date: Wed Jan 01 23:29:38 2014 +0800
 * $Author: jiakai <jia.kai66@gmail.com>
 */

#include "system.h"

#define IMAGE_WIDTH 400
#define IMAGE_HEIGHT 300
#define IMAGE_FLASH_PAGE_SIZE	(IMAGE_WIDTH * IMAGE_HEIGHT / 2)
#define IMAGE_FLASH_START	(1024 * 1024 / 2)
#define ANIMATION_SPEED 20
#define NAVBAR_WIDTH	44

static uint32_t saved_cp0_satus;

static void display_image(memio_ptr_t base) {
	int i, j;
	memio_ptr_t dest = vga_buffer;
	for (i = 0; i < IMAGE_HEIGHT; i ++) {
		for (j = 0; j < IMAGE_WIDTH; j += 2) {
			unsigned v = *base;
			*(dest ++) = v;
			*(dest ++) = v >> 8;
			base ++;
		}
		dest += VGA_ROW_SIZE - IMAGE_WIDTH;
	}
}

static void display_nonnavbar(memio_ptr_t base) {
	int i, j;
	memio_ptr_t dest = vga_buffer + NAVBAR_WIDTH;
	for (i = 0; i < IMAGE_HEIGHT; i ++) {
		base += NAVBAR_WIDTH / 2;
		for (j = 0; j < IMAGE_WIDTH - NAVBAR_WIDTH; j += 2) {
			unsigned v = *base;
			*(dest ++) = v;
			*(dest ++) = v >> 8;
			base ++;
		}
		dest += VGA_ROW_SIZE - (IMAGE_WIDTH - NAVBAR_WIDTH);
	}
}

static int compare_navbar_same(memio_ptr_t p0, memio_ptr_t p1) {
	int i, j;
	for (i = 0; i < IMAGE_HEIGHT; i ++) {
		for (j = 0; j < NAVBAR_WIDTH / 2; j ++)
			if (p0[j] != p1[j])
				return 0;
		p0 += IMAGE_WIDTH / 2;
		p1 += IMAGE_WIDTH / 2;
	}
	return 1;
}

static inline void play_animaion(memio_ptr_t addr,
		int delta, int navbar) {
	int i;
	if (navbar) {
		for (i = 0; i < IMAGE_HEIGHT / ANIMATION_SPEED; i ++) {
			addr += delta;
			display_image(addr);
		}
	} else {
		for (i = 0; i < IMAGE_HEIGHT / ANIMATION_SPEED; i ++) {
			addr += delta;
			display_nonnavbar(addr);
		}
	}
}

void umain(int argc, char **argv) {
	disable_interrupt(&saved_cp0_satus);
	memio_ptr_t addr = flash + IMAGE_FLASH_START;
	if (argc == 2)
		addr += (atoi(argv[1]) - 1) * IMAGE_FLASH_PAGE_SIZE;
	for (; ;) {
		display_image(addr);
		memio_ptr_t addr_next = addr + IMAGE_FLASH_PAGE_SIZE,
					addr_prev = addr - IMAGE_FLASH_PAGE_SIZE;
		int navbar_same_next = compare_navbar_same(addr, addr_next),
			navbar_same_prev = compare_navbar_same(addr, addr_prev);
		char ch = 0;
		while (!ch)
			ch = get_key();
		if (ch == 'q') {
			enable_interrupt(saved_cp0_satus);
			sys_redraw_console();
			sys_exit(0);
		}
		if (ch == 'j') {
			play_animaion(addr,
					IMAGE_WIDTH / 2 * ANIMATION_SPEED, !navbar_same_next);
			addr = addr_next;
		}
		if (ch == 'k') {
			play_animaion(addr,
					-IMAGE_WIDTH / 2 * ANIMATION_SPEED, !navbar_same_prev);
			addr = addr_prev;
		}
	}
}

void foo() {
	asm volatile (
			".globl _start\n"
			".extern _gp\n"
			"_start:\n"
			"la $gp, _gp\n"
			"addiu $sp, $sp, -16\n"
			"jal umain\n");
}

