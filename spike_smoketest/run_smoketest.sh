#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: CC0-1.0

# Perform a smoke-test of Spike: Simulate a small bare-metal RISC-V program
# that prints text to console using the Spike's HTIF interface.
# Check that the output is as expected.

set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

test_program="$script_dir/test_program/elf/hello.elf"
expected_file="${script_dir}/expected_output.txt"

if [ "$#" -ne 1 ]; then
    echo "Error: expected exactly one argument (the path to the spike executable)." >&2
    exit 1
fi

spike_bin="$1"

if [ ! -e "$spike_bin" ]; then
    echo "Error: '$spike_bin' does not exist." >&2
    exit 1
fi
if [ ! -x "$spike_bin" ]; then
    echo "Error: '$spike_bin' is not executable." >&2
    exit 1
fi

mkdir -p "$script_dir/spike_out"

"$spike_bin" \
    -m0x80000000:0x100000 \
    -p1 \
    --isa=rv32gc_zicsr \
    $test_program \
    >$script_dir/spike_out/spike_stdout.txt \
    2>$script_dir/spike_out/spike_stderr.txt

exit_status=$?

if [ "$exit_status" -ne 0 ]; then
    echo "Error: '$spike_bin' exited with status $exit_status, expected 0." >&2
    exit 1
fi

if ! diff -q "$script_dir/spike_out/spike_stdout.txt" "$expected_file"; then
    echo "Error: stdout of '$spike_bin' does not match '$expected_file'." >&2
    exit 1
fi

echo "OK: Spike successfully simulated a simple RISC-V program."
exit 0
