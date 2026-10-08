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

case "$1" in
    "ubuntu:jammy"|"ubuntu:noble"|"ubuntu:resolute"|"debian:12"|"debian:13")
        apt-get update
        apt-get install -y device-tree-compiler
        ;;
    "fedora:44"|"rockylinux:9"|"almalinux:10")
        dnf install -y diffutils dtc
        ;;
    "rockylinux:8")
        dnf install -y diffutils
        dnf install --enablerepo=devel -y dtc
        ;;
    *)
        echo "Don't know what dependencies to install on this system ($1)." >&2
        exit 2
        ;;
esac

exit 0
