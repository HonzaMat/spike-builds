<!--
SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
SPDX-License-Identifier: MIT
-->

# Binary builds of the RISC-V ISA Simulator

This project provides pre-built binaries of the
[Spike RISC-V ISA Simulator](https://github.com/riscv-software-src/riscv-isa-sim).

The Spike executables are portable and run on a wide range of Linux distributions on x86-64.

New releases are produced automatically every week and are available on the
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

```bash
# Download and extract a specific release:
$ export BUILD_DATE="20261018"
$ export URL="https://github.com/HonzaMat/spike-builds/releases/download/${BUILD_DATE}/riscv-isa-sim-${BUILD_DATE}-linux-x86-64.tar.gz"
$ wget "$URL"
$ tar xvf riscv-isa-sim-${BUILD_DATE}-linux-x86-64.tar.gz
$ riscv-isa-sim/bin/spike --help
```

**Tip: How to get the latest release**

Thanks to the [GitHub REST API](https://docs.github.com/en/rest/releases/releases?apiVersion=2026-03-10),
it is possible to to obtain the date and URL of the latest release (or a list of all releases)
in an automated way from your own programs or scripts.

Below are few quick examples.

<detail>
<summary>Examples for cURL + jq</summary>

```bash
# Get the latest release date (using curl + jq):
$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases/latest \
    | jq -r .tag_name
20261108

# Get the URL of the latest release (using curl + jq):
$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases/latest \
    | jq -r .assets[0].browser_download_url
https://github.com/HonzaMat/spike-builds/releases/download/20261108/riscv-isa-sim-20261108-linux-x86-64.tar.gz

# Get the dates of all published releases (using curl + jq):
$ curl -s -L \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2026-03-10" \
    https://api.github.com/repos/HonzaMat/spike-builds/releases \
    | jq -r .[].tag_name
20261108
20261101
20261025
...
```
</detail>

<detail>
<summary>Example for Python</summary>

```python
# Get all releases in Python:

from pprint import pprint

import requests

url = "https://api.github.com/repos/HonzaMat/spike-builds/releases"
headers = {
    "Accept": "application/vnd.github+json",
    "X-GitHub-Api-Version": "2026-03-10",
}

response = requests.get(url, headers=headers, allow_redirects=True)
response.raise_for_status()

data = response.json()
all_releases = [
    {"date": item["tag_name"], "url": item["assets"][0]["browser_download_url"]}
    for item in data
]

pprint(all_releases)

# This will output:

# [{'date': '20261108',
#   'url': 'https://github.com/HonzaMat/spike-builds/releases/download/20261108/riscv-isa-sim-20261108-linux-x86-64.tar.gz'},
#  {'date': '20261101',
#   'url': 'https://github.com/HonzaMat/spike-builds/releases/download/20261023/riscv-isa-sim-20261101-linux-x86-64.tar.gz'},
#  ...
#  ...
# ]

```
</detail>


## How it works

The automated build system for Spike works as follows:

1) Every day[^1], a GitHub Actions [workflow](https://github.com/HonzaMat/spike-builds/blob/main/.github/workflows/build_spike.yaml) is automatically triggered that handles the following steps.

2) The Spike source code is downloaded from the tip of the `master` branch of the [Spike upstream repository](https://github.com/riscv-software-src/riscv-isa-sim).

3) Spike is built in an older Linux environment so that the resulting binaries stay compatible with most current Linux distributions.
Docker image [`manylinux_2_28`](https://github.com/pypa/manylinux#manylinux_2_28-almalinux-8-based) from the _PyPA project_ is used for this purpose.

4) The resulting Spike build is then tested on multiple Linux distributions using short [smoke tests](https://github.com/HonzaMat/spike-builds/tree/main/spike_smoketests).

5) On Sundays only, if all checks pass, a release is published.


## Supported Linux distributions

The Spike builds released in this repository should work on all
x86-64 Linux distributions based on glibc&nbsp;>=&nbsp;2.28. Per the documentation of the
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
