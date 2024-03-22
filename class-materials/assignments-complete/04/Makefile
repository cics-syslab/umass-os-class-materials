O = build/obj
S = src
SC = scripts
B = build/bin

OBJS = \
	$O/entry.o \
	$O/main.o \
	$O/start.o \
	$O/util.o \
	$O/plic.o \
	$O/trap.o \
	$O/machinevec.o \
	$O/uart.o \
	$O/timer.o \
	$O/proc.o \
	$O/switch.o

# riscv64-unknown-elf- or riscv64-linux-gnu-
# perhaps in /opt/riscv/bin
#TOOLPREFIX = 

# Try to infer the correct TOOLPREFIX if not set
ifndef TOOLPREFIX
TOOLPREFIX := $(shell if riscv64-unknown-elf-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-elf-'; \
	elif riscv64-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-linux-gnu-'; \
	elif riscv64-unknown-linux-gnu-objdump -i 2>&1 | grep 'elf64-big' >/dev/null 2>&1; \
	then echo 'riscv64-unknown-linux-gnu-'; \
	else echo "***" 1>&2; \
	echo "*** Error: Couldn't find a riscv64 version of GCC/binutils." 1>&2; \
	echo "*** To turn off this error, run 'gmake TOOLPREFIX= ...'." 1>&2; \
	echo "***" 1>&2; exit 1; fi)
endif

QEMU = qemu-system-riscv64

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gas
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb -gdwarf-2
# Set standard march and mabi (in particular disables compressed instructions).
# Only increases binary size by 3% but simplifies binary interpretation by
# reducing instruction necessary to understand binary.
CFLAGS += -march=rv64g -mabi=lp64d
CFLAGS += -MD
CFLAGS += -mcmodel=medany
CFLAGS += -ffreestanding -fno-common -nostdlib -mno-relax
CFLAGS += -I./include
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

LDFLAGS = -z max-page-size=4096

$(B)/kernel: $(OBJS) $(SC)/kernel.ld
	$(LD) $(LDFLAGS) -T $(SC)/kernel.ld -o $(B)/kernel $(OBJS) 
	$(OBJDUMP) -S $(B)/kernel > $(B)/kernel.asm
	$(OBJDUMP) -t $(B)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(B)/kernel.sym

# Compile all .S files with CFLAGS as well
# instead of the implicit rule which seemingly ignores CFLAGS?
# The gap between cflags and -c is used to match the gap in
# the implict rules for .c files, it is purely aesthetic.
$(O)/%.o: $(S)/%.S
	$(CC) $(CFLAGS)   -c -o $@ $<

$(O)/%.o: $(S)/%.c
	$(CC) $(CFLAGS)   -c -o $@ $<

# This line tells the Makefile to use the .d (for dependency) files that we told gcc
# to generate with -MD. These dependency files contain rules that automatically
# recompile files if a header changes. This is very useful when we have parameters
# in a header that we might want to tweak before recompiling. The hyphen in front
# of include tells make to ignore these files if they don't exist (they get
# deleted every time we run make clean)
-include $(OBJS:.o=.d)

# Prevent deletion of intermediate files, e.g. cat.o, after first build, so
# that disk image changes after first build are persistent until clean.  More
# details:
# http://www.gnu.org/software/make/manual/html_node/Chained-Rules.html
.PRECIOUS: %.o

ifndef GDBPORT
# try to generate a unique GDB port
GDBPORT = $(shell expr `id -u` % 5000 + 25000)
endif
# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::$(GDBPORT)"; \
	else echo "-s -p $(GDBPORT)"; fi)
ifndef CPUS
CPUS := 1
endif

QEMUOPTS = -machine virt -bios none -kernel $(B)/kernel -m 128M -smp $(CPUS) -nographic

qemu: $(B)/kernel
	$(QEMU) $(QEMUOPTS) $(QEMUEXTRA)

qemu-gdb: $(B)/kernel .gdbinit
	@echo "*** Now run 'gdb' in another window." 1>&2
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB) $(QEMUEXTRA)

.PHONY: clean .gdbinit

clean: 
	rm -rf build/ .gdbinit 
	mkdir -p $(O) $(B)

.gdbinit:
ifdef DRIVERMODE
	sed "s/:1234/:$(GDBPORT)/" < $(SC)/.gdbinit.tmpl-riscv-driver > $@
else
	sed "s/:1234/:$(GDBPORT)/" < $(SC)/.gdbinit.tmpl-riscv > $@
endif