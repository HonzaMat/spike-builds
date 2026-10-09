#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

import argparse
import re
import subprocess
import sys
from pathlib import Path

ALLOWED_LIBRARIES = {
    "ld-linux-x86-64.so.2",
    "libc.so.6",
    "libgcc_s.so.1",
    "libm.so.6",
    "libstdc++.so.6",
    "linux-vdso.so.1",
}


def parse_args() -> str:
    parser = argparse.ArgumentParser(
        description=(
            "This script checks that an ELF binary only depends on a predefined "
            "set of shared libraries."
        )
    )
    parser.add_argument("binary", help="path to the ELF binary")
    args = parser.parse_args()
    return args.binary


def get_elf_dependencies(elf_path: Path) -> set[str]:
    result = subprocess.run(["ldd", "--", str(elf_path)], text=True, capture_output=True)
    if result.returncode:
        raise RuntimeError(f"ldd failed for '{elf_path}': {result.stderr or result.stdout}")

    deps = set()
    for line in result.stdout.splitlines():
        fields = line.split()
        if not fields:
            continue
        library = Path(fields[0]).name
        if re.search(r"\.so(?:\.|$)", library):
            deps.add(library)

    return deps


def main() -> int:
    binary_path = parse_args()
    try:
        deps = get_elf_dependencies(Path(binary_path))
    except RuntimeError as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

    unexpected_deps = deps - ALLOWED_LIBRARIES
    if unexpected_deps:
        print(
            f"Error: The binary '{binary_path}' depends on these unexpected shared libraries:",
            file=sys.stderr)
        print(*sorted(unexpected_deps), sep="\n", file=sys.stderr)
        return 2

    print(f"OK: The binary '{binary_path}' depends only on allowed shared libraries.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
