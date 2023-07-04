#!/usr/bin/env python3

# This script provides a simple mechanism for inhibiting system power management,
# or the screensaver, or both for the lifetime of a process.
#
# In KDE on Wayland, power saving is activated even when there are inputs on a
# gamepad. [1] This script inhibits power saving and the screensaver to prevent
# this issue.
#
# [1]: https://bugs.kde.org/show_bug.cgi?id=328987

import argparse
import asyncio
import subprocess
import sys
from typing import List

from dbus_fast.aio import MessageBus

FREEDESKTOP_POWER_MGMT_SERVICE = "org.freedesktop.PowerManagement.Inhibit"
FREEDESKTOP_SCREENSAVER_SERVICE = "org.freedesktop.ScreenSaver"


def arg_parser() -> argparse.ArgumentParser:
    a = argparse.ArgumentParser()
    a.add_argument(
        "--application-name", type=str, required=True,
        help="The application that is inhibiting the screensaver and power management."
    )
    a.add_argument(
        "--reason", type=str, required=True,
        help="The reason that the application is inhibiting the screensaver and power management."
    )
    a.add_argument(
        "--inhibit-power-management", type=bool, action=argparse.BooleanOptionalAction, default=True,
        help="Inhibits power management. By default, power management is inhibited."
    )
    a.add_argument(
        "--inhibit-screensaver", type=bool, action=argparse.BooleanOptionalAction, default=True,
        help="Inhibits the screensaver. By default, the screensaver is inhibited."
    )
    a.add_argument(
        "exe", nargs="+",
        help="The program to run."
    )
    return a


async def inhibit(
    application_name: str,
    reason: str,
    exe: List[str],
    inhibit_power_management: bool,
    inhibit_screensaver: bool,
) -> int:
    """
    Inhibits system power management or the screensaver, or both while an application is running.
    """
    if inhibit_power_management or inhibit_screensaver:
        bus = await MessageBus().connect()
        if inhibit_power_management:
            pm_inhibit = await get_dbus_interface(bus, FREEDESKTOP_POWER_MGMT_SERVICE)
            await pm_inhibit.call_inhibit(application_name, reason)
        if inhibit_screensaver:
            ss_inhibit = await get_dbus_interface(bus, FREEDESKTOP_SCREENSAVER_SERVICE)
            await ss_inhibit.call_inhibit(application_name, reason)
    proc = subprocess.run(exe, capture_output=False, check=False)
    return proc.returncode


async def main(args: List[str]) -> int:
    a = arg_parser().parse_args(args)
    exit_code = await inhibit(a.application_name, a.reason, a.exe, a.inhibit_power_management, a.inhibit_screensaver)
    return exit_code


async def get_dbus_interface(bus, service: str):
    """
    Gets a D-Bus interface that methods can be called on.

    Assumes that the service and path are the same, except that the path
    uses "/" as a separator instead of ".".
    """
    path = "/" + service.replace(".", "/")
    introspection = await bus.introspect(service, path)
    proxy_obj = bus.get_proxy_object(service, path, introspection)
    return proxy_obj.get_interface(service)


if __name__ == "__main__":
    sys.exit(asyncio.run(main(sys.argv[1:])))
