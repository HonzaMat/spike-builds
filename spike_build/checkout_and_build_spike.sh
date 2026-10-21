#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

# Check-out the source code of Spike and perform a build.

set -euox pipefail

git clone https://github.com/riscv-software-src/riscv-isa-sim.git \
  --recursive \
  --depth 1 \
  --recurse-submodules \
  --shallow-submodules

cd riscv-isa-sim

echo "Current Spike commit:"
git log -1

mkdir build && cd build
../configure --prefix=/opt/riscv-isa-sim

make -j`nproc`
make install

# Strip debug symbols from the binaries to considerably reduce their size
find /opt/riscv-isa-sim/bin -type f -executable | xargs strip --strip-unneeded
find /opt/riscv-isa-sim/lib -name "*.so" | xargs strip --strip-unneeded
