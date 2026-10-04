// SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
// SPDX-License-Identifier: CC0-1.0

    .section .init
    .global _start
    .type _start, @function

_start:
    .cfi_startproc
    .cfi_undefined ra

.option push
.option norelax
    la  gp, __global_pointer$
.option pop

    la sp, _stack_top

    // Load data section
    la a0, _data_lma
    la a1, _data
    la a2, _edata
    bgeu a1, a2, 2f
1:
    lw t0, (a0)
    sw t0, (a1)
    addi a0, a0, 4
    addi a1, a1, 4
    bltu a1, a2, 1b
2:

    // Clear bss section
    la a0, _bss
    la a1, _ebss
    bgeu a0, a1, 2f
1:
    sw zero, (a0)
    addi a0, a0, 4
    bltu a0, a1, 1b
2:

    li  a0, 0
    li  a1, 0
    li  a2, 0
    jal main

1:
    wfi
    j 1b

    .cfi_endproc
