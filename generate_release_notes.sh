#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: CC0-1.0

# Generate release notes text for a release on GitHub.

if [ "$#" -ne 2 ]; then
    echo "Error: expected exactly two arguments - build date and Spike commit hash." >&2
    exit 1
fi

set -euo pipefail

build_date="$1"
spike_commit="$2"
spike_commit_short="${2:0:8}"

echo "Build date: $build_date" >&2
echo "Spike commit: $spike_commit" >&2

cat <<EOF | tr '\n' ' '
Portable binary build of [Spike RISC-V ISA simulator](https://github.com/riscv-software-src/riscv-isa-sim)
for Linux x86-64 platforms. It was automatically created on **$build_date** from Spike's upstream commit
**[$spike_commit_short](https://github.com/riscv-software-src/riscv-isa-sim/commit/$spike_commit)**.
EOF

echo ""
echo ""

cat <<EOF | tr '\n' ' '
See the [Readme file](https://github.com/HonzaMat/spike-builds/blob/main/README.md)
for more information.
EOF

echo ""
