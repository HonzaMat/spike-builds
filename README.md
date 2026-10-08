<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: MIT
-->

# Binary builds of the RISC-V ISA Simulator

This project provides pre-built binaries of the
[Spike RISC-V ISA Simulator](https://github.com/riscv-software-src/riscv-isa-sim).

The builds are portable and should run on a wide range of Linux distributions on x86-64.

New builds are produced automatically every week and are available on the
[Releases page](https://github.com/HonzaMat/spike-builds/releases) of this repository.

## 🚧 TODO 🚧

**This project is currently under development.**

The README is incomplete and will be expanded over time.

## Quick start

**1) Install the Device Tree Compiler**

The Device Tree Compiler (`dtc`) is a runtime dependency of Spike and must be installed on your system.

```bash
# Rocky Linux / AlmaLinux 8:
sudo dnf install --enablerepo=devel -y dtc

# Rocky Linux / AlmaLinux 9, 10, or Fedora:
sudo dnf install -y dtc

# Debian / Ubuntu:
sudo apt-get update
sudo apt-get install -y device-tree-compiler
```

**2) Download and extract a binary build of Spike**

Find the desired release on the [Releases page](https://github.com/HonzaMat/spike-builds/releases).

Then download and extract it, for example:

```
wget https://github.com/HonzaMat/spike-builds/releases/download/<BUILD_DATE>/riscv-isa-sim.tar.gz

tar xvf riscv-isa-sim.tar.gz

riscv-isa-sim/bin/spike --help
```

## How it works

The automated process build system for Spike works this way:

1) Every day[^1], a GitHub Actions [workflow](https://github.com/HonzaMat/spike-builds/blob/main/.github/workflows/build_spike.yaml) is automatically triggered that handles the following steps.

2) Source code of Spike is downloaded from the tip of the `master` branch of the [Spike's repository](https://github.com/riscv-software-src/riscv-isa-sim).

3) Spike is built in an older Linux environment so that the resulting binaries remain compatible with most current Linux distributions.
Docker image [`manylinux_2_28`](https://github.com/pypa/manylinux#manylinux_2_28-almalinux-8-based) from the _PyPA project_ is used for this purpose.

4) The resulting Spike build is then tested on multiple Linux distributions using a short [smoke test](https://github.com/HonzaMat/spike-builds/tree/main/spike_smoketest).

5) On Sundays only, and if all of the above passes, a release is published.


## Supported Linux distributions

The Spike builds released in this repository should be compatible with all
x86-64 Linux distributions based on glibc >= 2.28. Per the documentation of the
`manylinux_2_28` image, which serves as the build environment, this includes:

- Debian 10+
- Ubuntu 18.10+
- Fedora 29+
- RHEL / Rocky / AlmaLinux 8+

If you run into any compatibility problems, please open
an [issue](https://github.com/HonzaMat/spike-builds/issues).


## Disclaimer

This project is not affiliated with the Spike RISC-V ISA Simulator project.
It is an independent project maintained by its author.

The Spike binaries produced by this project are provided on a **best-effort** basis.
They are provided with the best intentions, but without any guarantees regarding
compatibility, correctness, or availability.


## Licensing

Spike RISC-V ISA Simulator itself is distributed under the terms of
the 3-clause BSD License. See the
[LICENSE file](https://github.com/riscv-software-src/riscv-isa-sim/blob/master/LICENSE)
in the Spike's repository.

The components of the automated build system in this repository are, with a few
exceptions, published under the terms of the MIT license.


## Submitting fixes or suggestions

If you encounter an issue or have a suggestion for improving the automated build system,
please feel free to open an [issue](https://github.com/HonzaMat/spike-builds/issues)
or submit a [pull request](https://github.com/HonzaMat/spike-builds/pulls). Thank you!


[^1]: The automated build runs every day to catch any issues or instability. However, a release is only made once a week.
