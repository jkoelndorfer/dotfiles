#!/usr/bin/env python3

import os
import sys
import time

try:
    import serial
except ImportError:
    print("Could not import the serial module!", file=sys.stderr)
    print("Install the python-pyserial package on Arch.", file=sys.stderr)
    exit(1)


class IogearGHSW8141:
    def __init__(self, device_path: str):
        self.serial = serial.Serial(
            port=device_path,
            baudrate=19200,
            bytesize=serial.EIGHTBITS,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
        )

    def close(self):
        self.serial.close()

    def send_command(self, command: str):
        self.serial.write(b"\r\n")
        time.sleep(0.25)
        commandb = command.encode("ascii")
        self.serial.write(commandb + b"\r\n")

    def set_power_on_detection(self, state: bool):
        state_str = {
            True: "on",
            False: "off"
        }
        self.send_command(f"pod {state_str}")

    def set_input(self, input: int):
        self.send_command(f"sw i{input:02d}")

    def next_input(self):
        self.send_command("sw +")

    def previous_input(self):
        self.send_command("sw -")


def iog_factory() -> IogearGHSW8141:
    try:
        device_path = os.environ["HDMI_SWITCH_DEVICE_PATH"]
    except KeyError:
        print("HDMI_SWITCH_DEVICE_PATH is not defined in the environment.", file=sys.stderr)
        print("It should look something like '/dev/ttyUSB0'.", file=sys.stderr)
        exit(1)
    return IogearGHSW8141(device_path)


if __name__ == "__main__":
    iog = iog_factory()
    iog.set_input(int(sys.argv[1]))
    iog.close()
