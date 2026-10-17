#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

# Install the needed dependencies to run & test Spike:
# - Device tree compiler - runtime dependency of Spike
# - diff - needed for run_smoketest.sh

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Error: expected exactly one argument - name of the docker image." >&2
    exit 1
fi

# Install the required packages:
# - dtc - runtime dependency of Spike
# - wget - need to download Python
case "$1" in
    "ubuntu:jammy"|"ubuntu:noble"|"ubuntu:resolute"|"debian:12"|"debian:13")
        apt-get update
        apt-get install -y device-tree-compiler wget
        ;;
    "fedora:44"|"rockylinux:9"|"almalinux:10")
        dnf install -y dtc wget
        ;;
    "rockylinux:8")
        dnf install --enablerepo=devel -y dtc wget
        ;;
    *)
        echo "Don't how to install needed dependencies on this system ($1)." >&2
        exit 2
        ;;
esac

# Download a portable, standalone Python package
PYTHON_URL="https://github.com/astral-sh/python-build-standalone/releases/download/20261009/cpython-3.14.8+20261009-x86_64_v2-unknown-linux-gnu-freethreaded-install_only_stripped.tar.gz"
EXPECTED_SHA256="1fe9d810548381ddd2bed81a139550d98d6cddb481e3b7470ff99947a5f0feed"
TAR_GZ_FILE="cpython.tar.gz"

wget "$PYTHON_URL" -O $TAR_GZ_FILE

if ! echo "$EXPECTED_SHA256  $TAR_GZ_FILE" | sha256sum -c -; then
    echo "ERROR: SHA256 checksum check failed for the downloaded python package" >&2
    exit 3
fi

tar -xvf $TAR_GZ_FILE -C /opt
