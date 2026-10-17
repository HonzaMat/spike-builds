
# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

.PHONY: all disasm_hello disasm_infinite_loop download_toolchain clean

TOOLCHAIN_URL = https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v15.2.0-1/xpack-riscv-none-elf-gcc-15.2.0-1-linux-x64.tar.gz
TOOLCHAIN_FOLDER = xpack-riscv-none-elf-gcc-15.2.0-1
TOOLCHAIN_ARCHIVE = $(TOOLCHAIN_FOLDER)-linux-x64.tar.gz

RISCV_CC ?= toolchain/$(TOOLCHAIN_FOLDER)/bin/riscv-none-elf-gcc
RISCV_OBJDUMP ?= toolchain/$(TOOLCHAIN_FOLDER)/bin/riscv-none-elf-objdump

CFLAGS = \
    -march=rv32gc_zicsr \
	-mabi=ilp32 \
	-std=c99 \
	-Wall -Werror \
	-g3

LDFLAGS = \
    -nostartfiles \
	-march=rv32gc_zicsr \
	-mabi=ilp32 \
	-mcmodel=medany \
	-Xlinker --defsym=__stack_size=2048

all:
	$(RISCV_CC) $(CFLAGS) -c src/start.S -o elf/start.o
	$(RISCV_CC) $(CFLAGS) -c src/htif.c -o elf/htif.o
	$(RISCV_CC) $(CFLAGS) -c src/hello_world.c -o elf/hello_world.o
	$(RISCV_CC) $(CFLAGS) -c src/infinite_loop.c -o elf/infinite_loop.o
	$(RISCV_CC) $(LDFLAGS) \
	    elf/htif.o elf/hello_world.o elf/start.o -o elf/hello_world.elf \
		-Tsrc/link.ld
	$(RISCV_CC) $(LDFLAGS) \
	    elf/htif.o elf/infinite_loop.o elf/start.o -o elf/infinite_loop.elf \
		-Tsrc/link.ld

disasm_hello:
	$(RISCV_OBJDUMP) -d -S elf/hello_world.elf

disasm_infinite_loop:
	$(RISCV_OBJDUMP) -d -S elf/infinite_loop.elf

download_toolchain:
	mkdir -p ./toolchain && \
	cd ./toolchain && \
	wget $(TOOLCHAIN_URL) -O $(TOOLCHAIN_ARCHIVE) && \
	sha256sum --check < ../$(TOOLCHAIN_ARCHIVE).sha && \
	tar xvf $(TOOLCHAIN_ARCHIVE)

clean:
	rm -f elf/*.o elf/*.elf
