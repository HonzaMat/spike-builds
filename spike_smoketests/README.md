<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: MIT
-->

# Spike Smoke Tests

This directory contains smoke tests for the Spike RISC-V ISA simulator.

The tests are run on every Spike build as a basic validation that the simulator
is functioning correctly.

Currently, there are two tests:

- `test_hello_world`: Checks that Spike is able to simulate a simple
  RISC-V bare-metal program that prints a short message to the standard output
  using Spike's HTIF (Host-Target Interface).

- `test_jtag_remote_bitbang`: Verifies Spike's remote bitbang
  server interface by connecting to it and performing a few JTAG operations.

The bare-metal programs needed for the tests are stored in `programs/elf` directory
as ELF binaries. This is to avoid the need to download a bare-metal RISC-V toolchain
and recompile the programs for every test run.

Source code for the programs can be found in the `programs/src` directory.

