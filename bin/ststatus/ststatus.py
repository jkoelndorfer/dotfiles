#!/usr/bin/env python3

from enum import auto, Enum
from os import environ
from pathlib import Path
import signal
from subprocess import run
from typing import Optional
from xml.sax import parse as xml_parse
from xml.sax.handler import ContentHandler as XMLContentHandler

from PySide6.QtCore import QTimer
from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QApplication, QSystemTrayIcon

import requests

# Signal handling research:
# https://stackoverflow.com/questions/4938723/what-is-the-correct-way-to-make-my-pyqt-application-quit-when-killed-from-the-co
# https://doc.qt.io/qt-6/unix-signals.html


class SyncthingError(Exception):
    """
    Exception raised for Syncthing-related errors.
    """


class SyncthingConfigParseError(SyncthingError):
    """
    Exception raised when parsing Syncthing configuration fails.
    """


class SyncthingApiError(SyncthingError):
    """
    Exception raised when interacting with the Syncthing API fails.
    """


class SyncthingDeviceStatus(Enum):
    # The status of the device could not be determined, possibly due
    # to an error interacting with the Syncthing API.
    UNKNOWN_STATUS = auto()

    # The device is not known to Syncthing.
    UNKNOWN_DEVICE = auto()

    # The device is not currently connected.
    OFFLINE = auto()

    # The device is currently connected.
    CONNECTED = auto()


class SyncthingClient:
    def __init__(self, syncthing_url: str, api_key: str, requests_session: Optional[requests.Session] = None) -> None:
        if requests_session is not None:
            self.requests = requests_session
        else:
            self.requests = requests.Session()
        self.syncthing_url = syncthing_url
        self.requests.headers = {"X-API-Key": api_key}

    def device_connected(self, device_id: str) -> SyncthingDeviceStatus:
        """
        Returns True if the device given by `device_id` is connected, False otherwise.
        """
        resp = self.requests.get(f"{self.syncthing_url}/rest/system/connections", timeout=3)
        if resp.status_code >= 500:
            raise SyncthingApiError(f"syncthing internal error code: {resp.status_code}")
        elif resp.status_code >= 400:
            raise SyncthingApiError(f"syncthing client error code: {resp.status_code}")

        resp_dict = resp.json()
        try:
            device_connected = resp_dict["connections"].get(device_id, {}).get("connected", None)
        except KeyError:
            return SyncthingDeviceStatus.UNKNOWN_STATUS

        if device_connected is None:
            return SyncthingDeviceStatus.UNKNOWN_DEVICE
        elif device_connected is False:
            return SyncthingDeviceStatus.OFFLINE
        elif device_connected is True:
            return SyncthingDeviceStatus.CONNECTED
        else:
            # This should never happen.
            raise SyncthingApiError(f"syncthing API returned unexpected connected status '{device_connected}'")

    @property
    def web_ui_url(self):
        return self.syncthing_url


class SyncthingXMLHandler(XMLContentHandler):
    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.record_api_key = False
        self.syncthing_api_key = ""

    def startElement(self, name: str, attrs) -> None:
        if name == "apikey":
            self.record_api_key = True

    def endElement(self, name: str) -> None:
        self.record_api_key = False

    def characters(self, content: str) -> None:
        if not self.record_api_key:
            return
        self.syncthing_api_key += content


class SyncthingSystemTrayApp:
    def __init__(self) -> None:
        self.app = QApplication()
        self.app.setQuitOnLastWindowClosed(False)

    def configure_signal_handler(self) -> None:
        for s in [signal.SIGINT, signal.SIGTERM]:
            signal.signal(s, signal.SIG_DFL)

    def configure_syncthing_client(self) -> None:
        default_syncthing_config_path = Path.home() / ".config" / "syncthing" / "config.xml"
        default_syncthing_url = "http://localhost:8384"

        syncthing_config_path = environ.get("SYNCTHING_CONFIG_PATH", default_syncthing_config_path)
        syncthing_url = environ.get("SYNCTHING_URL", default_syncthing_url)
        xml_handler = SyncthingXMLHandler()
        xml_parse(syncthing_config_path, xml_handler)

        if not xml_handler.syncthing_api_key:
            raise SyncthingConfigParseError("Failed getting API key from Syncthing configuration")

        self.syncthing_client = SyncthingClient(syncthing_url, xml_handler.syncthing_api_key)

    def configure_systray_update(self) -> None:
        device_id = environ.get("SYNCTHING_CENTRAL_DEVICE_ID", None)
        self.systray_icon = SystemTrayIcon(self.syncthing_client, device_id, self.app)
        self.systray_icon.show()

        self.timer = QTimer(self.app)
        self.timer.timeout.connect(self.systray_icon.update_icon)
        self.timer.setInterval(5000)
        self.timer.start()

    def run(self) -> None:
        self.configure_signal_handler()
        self.configure_syncthing_client()
        self.configure_systray_update()
        self.app.exec()

    def shutdown(self) -> None:
        self.app.shutdown()


class SystemTrayIcon(QSystemTrayIcon):
    def __init__(self, syncthing_client: SyncthingClient, device_id: Optional[str], *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.syncthing_client = syncthing_client
        self.device_id = device_id
        self.syncthing_connected_icon = QIcon("/usr/share/icons/breeze-dark/status/16/state-ok.svg")
        self.syncthing_offline_icon = QIcon("/usr/share/icons/breeze-dark/status/16/state-offline.svg")
        self.syncthing_warning_icon = QIcon("/usr/share/icons/breeze-dark/status/16/state-warning.svg")
        self.syncthing_error_icon = QIcon("/usr/share/icons/breeze-dark/status/16/state-error.svg")
        self.activated.connect(self.show_syncthing)
        self.update_icon()

    def update_icon(self):
        if self.device_id is None:
            self.set_status(SyncthingDeviceStatus.UNKNOWN_STATUS)
            return
        device_connected = self.syncthing_client.device_connected(self.device_id)
        self.set_status(device_connected)

    def set_status(self, status: SyncthingDeviceStatus) -> None:
        if status == SyncthingDeviceStatus.OFFLINE:
            self.setIcon(self.syncthing_offline_icon)
            status_text = "offline"
        elif status == SyncthingDeviceStatus.CONNECTED:
            self.setIcon(self.syncthing_connected_icon)
            status_text = "connected"
        elif status == SyncthingDeviceStatus.UNKNOWN_DEVICE:
            self.setIcon(self.syncthing_warning_icon)
            status_text = "unknown device"
        elif status == SyncthingDeviceStatus.UNKNOWN_STATUS:
            self.setIcon(self.syncthing_error_icon)
            status_text = "API error or null device ID"
        else:
            # This should not happen.
            self.setIcon(self.syncthing_error_icon)
            status_text = "unknown"
        self.setToolTip(f"syncthing status: {status_text}")

    def show_syncthing(self, reason: QSystemTrayIcon.ActivationReason) -> None:
        if reason == QSystemTrayIcon.ActivationReason.Trigger:
            run(["xdg-open", self.syncthing_client.web_ui_url], capture_output=True)


if __name__ == "__main__":
    app = SyncthingSystemTrayApp()
    app.run()
