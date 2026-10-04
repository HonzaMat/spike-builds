<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: CC0-1.0
-->

# Binary builds of Spike -- RISC-V ISA Simulator

This project produces portable binary builds of Spike -- the RISC-V ISA simulator.
The produced builds are portable -- they will run on almost any Linux x86-64 distribution.

The builds are produced every week in an automated way.

## TODO

**🚧 This project is currently in development phase. 🚧**

**This Readme file is incomplete and will be expanded.**


## Quick start - how to use the binary builds of Spike

Install Device Tree Compiler on your system because it is a runtime dependency of Spike:

```bash
# RockyLinux/AlmaLinux 8:
$ sudo dnf install --enablerepo=devel -y dtc

# RockyLinux/AlmaLinux 9, 10 or Fedora:
$ sudo dnf install -y dtc

# Debian or Ubuntu:
$ sudo apt-get update && sudo apt-get install -y device-tree-compiler

```

Download a package with binary builds from the [Releases page](https://github.com/HonzaMat/spike-builds/releases/)
of this repository. Then extract the archive and start using Spike:

```bash
$ wget https://github.com/HonzaMat/spike-builds/releases/download/<BUILD_DATE>/riscv-isa-sim.tar.gz
$ tar xvf riscv-isa-sim.tar.gz
$ riscv-isa-sim/bin/spike --help

```

## Disclaimer

This project is not affiliated with the RISC-V ISA simulator project.
It is and independent initiative of its author.

The builds of Spike produced in this project are provided on "best effort" basis --
with best intentions but without any guarantees.

If you find an issue or have a suggestion for improvement of this automated build
system, please feel free to open a Github issue or submit a pull request -- thank you.

