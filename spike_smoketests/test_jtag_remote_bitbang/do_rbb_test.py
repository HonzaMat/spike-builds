#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Jan Matyas <info@janmatyas.net>
# SPDX-License-Identifier: MIT

import argparse
import shlex
import socket
import subprocess
import sys
import time
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent.resolve()
INFINITE_LOOP_ELF = (SCRIPT_DIR / "../programs/elf/infinite_loop.elf").resolve()

SPIKE_PORT = 9824


def _parse_args() -> str:
    parser = argparse.ArgumentParser(
        description=(
            "This script performs a smoke-test of the Spike's JTAG (remote bitbang) "
            "interface by trying a few simple JTAG transactions."
        )
    )
    parser.add_argument("spike_bin", type=Path, help="path to the Spike executable")
    args = parser.parse_args()
    return args.spike_bin


# Description of the remote bitbang protocol can be found at:
# https://github.com/openocd-org/openocd/blob/79b51fedab9e8023a2e72551c4dcaf4373274287/doc/manual/jtag/drivers/remote_bitbang.txt


def _add_reset_symbol(data: bytearray, trst: bool, srst: bool) -> None:
    symbol = ord("r") + (2 if trst else 0) + (1 if srst else 0)
    data.append(symbol)


def _add_clock_cycle(
    data: bytearray, tms: bool, tdi: bool, sample_tdo: bool = False
) -> None:
    # TCK low, TMS and TDI as requested:
    data.append(ord("0") + (2 if tms else 0) + (1 if tdi else 0))
    # Sample TDO
    if sample_tdo:
        data.append(ord("R"))
    # TCK high, TMS and TDI as requested
    data.append(ord("4") + (2 if tms else 0) + (1 if tdi else 0))


def _prepare_jtag_operations() -> bytes:
    data_to_send = bytearray()

    # Reset the JTAG TAP
    _add_reset_symbol(data_to_send, trst=False, srst=False)

    # Transition to the Shift-DR JTAG state
    # TLR --> RTI --> Select-DR --> Capture-DR --> Shift-DR
    #      0       1             0              0
    _add_clock_cycle(data_to_send, tms=False, tdi=False)
    _add_clock_cycle(data_to_send, tms=True, tdi=False)
    _add_clock_cycle(data_to_send, tms=False, tdi=False)
    _add_clock_cycle(data_to_send, tms=False, tdi=False)

    # Shift 64 bits equal to '1'.
    # Set TMS for the last bit to '1', which causes state
    # transition Shift-DR --> Exit1-DR.
    for _ in range(63):
        _add_clock_cycle(data_to_send, tms=False, tdi=True, sample_tdo=True)
    _add_clock_cycle(data_to_send, tms=True, tdi=True, sample_tdo=True)

    # Transition back to the RTI state.
    # Exit1-DR --> Update-DR --> RTI
    #           1             0
    _add_clock_cycle(data_to_send, tms=True, tdi=False)
    _add_clock_cycle(data_to_send, tms=False, tdi=False)

    return bytes(data_to_send)


def _get_spike_cmd(spike_bin: Path) -> list[str]:
    return [
        str(spike_bin),
        "-m0x80000000:0x100000",
        "-p1",
        "--isa=rv32gc_zicsr",
        f"--rbb-port={SPIKE_PORT}",
        str(INFINITE_LOOP_ELF),
    ]


def _send_and_receive(
    spike_host: str, spike_port: int, data_to_send: bytes, num_recv: int, timeout: int
) -> bytes:

    with socket.create_connection((spike_host, spike_port), timeout=timeout) as sock:
        sock.sendall(data_to_send)

        deadline = time.monotonic() + timeout
        response = bytearray()

        while len(response) < num_recv:
            remaining_time = deadline - time.monotonic()
            if remaining_time <= 0:
                raise TimeoutError(
                    f"Spike did not send us requested {num_recv} bytes within "
                    f"{timeout} seconds"
                )

            chunk = sock.recv(num_recv - len(response))
            if not chunk:
                raise ConnectionError(
                    "Spike unexpectedly disconnected - before sending "
                    "the expected 64 bytes"
                )
            response.extend(chunk)

    return bytes(response)


def _response_to_int(response: bytes) -> int:
    if any(b not in [ord("0"), ord("1")] for b in response):
        raise ValueError("The response from Spike contains illegal characters")

    # LSB is at response[0], so reversal is necessary.
    return int(bytes(reversed(response)), 2)


def main() -> int:
    spike_bin = _parse_args()
    spike_cmd = _get_spike_cmd(spike_bin)
    data_to_send = _prepare_jtag_operations()

    print("Launching Spike: " + shlex.join(spike_cmd))
    spike_proc = subprocess.Popen(spike_cmd, stdin=subprocess.DEVNULL)

    try:
        # Avoid races, give spike enough time to start up.
        time.sleep(1.0)

        print("Trying simple JTAG transactions ...")
        print("Raw data sent to Spike: " + repr(data_to_send))
        response = _send_and_receive(
            "127.0.0.1", SPIKE_PORT, data_to_send, num_recv=64, timeout=2
        )
        print("Raw response from Spike: " + repr(response))

    finally:
        if spike_proc.poll() is None:
            print("Terminating Spike ...")
            spike_proc.kill()

    decoded_response = _response_to_int(response)
    print(f"Decoded response: 0x{decoded_response:016x}")

    # The lower 32 bits of the response must be JTAG IDCODE
    # used by Spike which is 0xdeadbeef.
    #
    # The upper 32 bits must be all ones. These are the '1' bits
    # that we shifted into the JTAG chain, which are already coming through.
    if decoded_response != 0xFFFFFFFF_DEADBEEF:
        print("Error: The response from Spike is unexpected")
        return 1

    print("OK: Received expected response from Spike")
    return 0


if __name__ == "__main__":
    sys.exit(main())
