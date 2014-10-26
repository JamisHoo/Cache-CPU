# $File: Makefile
# $Date: Fri Dec 20 21:39:20 2013 +0800
# $Author: jiakai <jia.kai66@gmail.com>

BUILD = build
BIN = bin

GCCPREFIX = mips-sde-elf-

AS = $(GCCPREFIX)as
LD = $(GCCPREFIX)ld
CC = $(GCCPREFIX)gcc

DECAF = ../../../decaf/result/decaf.jar

CFLAGS = -mips1 -O2 -fno-builtin -nostdlib  -nostdinc -G0 -Wformat -EL -Wall -Werror
ASFLAGS = -EL -mips32
LDFLAGS = -S -Tuser.ld ../../obj/user/libuser.a

all: $(BIN)/hanoi  $(BIN)/hello 

$(BUILD)/%.decaf.s: %.decaf $(DECAF)
	@[ -d $(BUILD) ] || mkdir $(BUILD)
	java -jar $(DECAF) $< > $@

$(BUILD)/%.decaf.o: $(BUILD)/%.decaf.s
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/%.s.o: %.s 
	$(AS) $(ASFLAGS) $< -o $@

$(BUILD)/%.c.o: %.c
	$(CC) $(CFLAGS) -I../../user/libs -I../../kern/include -c $< -o $@

$(BIN)/%: $(BUILD)/%.decaf.o $(BUILD)/entry.s.o $(BUILD)/userlib.c.o
	@[ -d $(BIN) ] || mkdir $(BIN)
	$(LD) $(LDFLAGS) $^ -o $@

clean:
	rm -rf $(BUILD) $(BIN)

.PHONY: all clean
