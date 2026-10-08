#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

# Create a tar.gz archive with the spike binary build.

set -euox pipefail

TARGET_DIR=/opt/riscv-isa-sim

mkdir -p $TARGET_DIR/share/spike

# Store the build log
cp build_log.txt $TARGET_DIR/share/spike

# Store the license & git commit information
cd riscv-isa-sim
cp LICENSE $TARGET_DIR/share/spike/spike_license.txt
git show >$TARGET_DIR/share/spike/git_commit.txt

# Make the package
cd ..
tar -czvf riscv-isa-sim.tar.gz -C /opt riscv-isa-sim
