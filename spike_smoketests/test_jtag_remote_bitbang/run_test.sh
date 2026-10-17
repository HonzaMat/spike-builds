#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

# Perform a smoke-test of Spike: Launch spike and try to communicate with
# its simulated JTAG interface using the remote bitbang protocol.

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "Error: expected exactly one argument (the path to the spike executable)." >&2
    exit 1
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

/opt/python/bin/python3 "$script_dir/do_rbb_test.py" "$1"
