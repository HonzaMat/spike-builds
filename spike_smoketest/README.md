<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: MIT
-->

# Spike Smoke Test

This directory contains a simple smoke test for the Spike RISC-V ISA simulator.

The test is run on every automatically generated Spike build as a basic check
that the simulator is functioning correctly.

- The `run_smoketest.sh` script runs a small RISC-V bare-metal program `elf/hello.elf` using Spike.
- The bare-metal program prints text to Spike's output via the Spike's HTIF (Host-Target Interface).
- The script then compares the program's output with the expected text.

The test program is stored in the repository as an ELF binary to avoid the need to download
a bare-metal RISC-V toolchain and recompile the program for every test run.

The source code for `hello.elf` can be found in the `src` folder if you need to inspect,
troubleshoot, or modify the test.
