/*
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: CC0-1.0
*/

OUTPUT_ARCH( "riscv" )
ENTRY( _start )

MEMORY
{
	rom (rxa) : ORIGIN = 0x80000000, LENGTH = 256K
	ram (wxa) : ORIGIN = 0x80000000 + 256K, LENGTH = 256K
}

SECTIONS
{
	.init :
	{
		KEEP (*(SORT_NONE(.init)))
	} >rom AT>rom

	.text :
	{
		*(.text.unlikely .text.*_unlikely .text.unlikely.*)
		*(.text.exit .text.exit.*)
		*(.text.startup .text.startup.*)
		*(.text.hot .text.hot.*)
		*(SORT(.text.sorted.*))
		*(.text .stub .text.* .gnu.linkonce.t.*)
	} >rom AT>rom

	.fini :
	{
		KEEP (*(SORT_NONE(.fini)))
	} >rom AT>rom

	.rodata.align ALIGN(8):
	{
	} >rom AT>rom

	.rodata :
	{
		*(.rodata .rodata.* .gnu.linkonce.r.*)
		. = ALIGN(8);
	} >rom AT>rom

	.data.align :
	{
		. = ALIGN(8);
		_data = .;
	} >ram AT>rom

	.data :
	{
    	*(.data .data.* .gnu.linkonce.d.*)
		. = ALIGN(8);
		PROVIDE( __global_pointer$ = . + 0x800 );
		*(.srodata.cst16)
		*(.srodata.cst8)
		*(.srodata.cst4)
		*(.srodata.cst2)
		*(.srodata .srodata.*)
		*(.sdata .sdata.* .gnu.linkonce.s.*)
		. = ALIGN(8);
		_edata = .;
	} >ram AT>rom

	PROVIDE (_data_lma = LOADADDR(.data));

	.bss.align :
	{
		. = ALIGN(8);
		_bss = .;
	} >ram AT>rom

	.bss :
	{
		*(.dynsbss)
		*(.sbss .sbss.* .gnu.linkonce.sb.*)
		*(.dynbss)
		*(.bss .bss.* .gnu.linkonce.b.*)
		*(COMMON)
		. = ALIGN(8);
		_ebss = .;
	} >ram AT>rom

	. = ALIGN(8);
	_end = .;

	.stack :
	{
		. = ALIGN(16);
		. += __stack_size;
		_stack_top = .;
	} >ram AT>ram
}