
# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: CC0-1.0

.PHONY: all disasm download_toolchain clean

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
	$(RISCV_CC) $(CFLAGS) -c src/htif.c -o elf/htif.o
	$(RISCV_CC) $(CFLAGS) -c src/hello.c -o elf/hello.o
	$(RISCV_CC) $(CFLAGS) -c src/start.S -o elf/start.o
	$(RISCV_CC) $(LDFLAGS) \
	    elf/htif.o elf/hello.o elf/start.o -o elf/hello.elf \
		-Tsrc/link.ld

disasm:
	$(RISCV_OBJDUMP) -d -S elf/hello.elf

download_toolchain:
	cd ./toolchain && \
	wget $(TOOLCHAIN_URL) -O $(TOOLCHAIN_ARCHIVE) && \
	sha256sum --check < ../$(TOOLCHAIN_ARCHIVE).sha && \
	tar xvf $(TOOLCHAIN_ARCHIVE)

clean:
	rm -f elf/*.o elf/hello.elf
