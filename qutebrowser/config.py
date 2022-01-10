# flake8: noqa: E221

from qutebrowser import __version_info__ as qutebrowser_version  # tuple like (1, 11, 0)
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import os
import subprocess
from typing import Dict, List

dotfile_dir = os.environ["DOTFILE_DIR"]
display_profile_output = subprocess.run([f"{dotfile_dir}/bin/gui/display-profile"], capture_output=True)
display_profile = display_profile_output.stdout.decode("utf-8").strip()

if qutebrowser_version >= (2, 2, 0):
    content_notifications_enabled = "content.notifications.enabled"
else:
    content_notifications_enabled = "content.notifications"

url_permissions: Dict[str, Dict[bool, List[str]]] = {
    # Controls the ability of sites to register themselves
    # as a protocol handler.
    "content.register_protocol_handler": {
        True: [
            # Needed for mailto: links.
            "https://mail.google.com/*",
            # Needed for webcal links.
            "https://calendar.google.com/*",
        ],
        False: [],
    },
    "content.javascript.can_open_tabs_automatically": {
        True: [
            # Allow popups for my bank's online portal.
            "https://www.financial-net.com/*",
        ],
        False: [],
    },
    content_notifications_enabled: {
        True: [],
        False: [
            "https://www.reddit.com",
        ],
    },
    # Audio and video capture requires special permission configuration.
    # Set those in url_permissions_media below.
}

# URLs that are allowed to capture audio and video.
url_permissions_media = [
    "https://duo.google.com",
    "https://meet.google.com",
    "https://meet.google.com/*",
    "https://mail.google.com",
    "https://hangouts.google.com",
    "https://*.slack.com",
    "https://meet.jit.si",
]

# URLs that bypass adblocking.
adblock_whitelist_urls = [
    # This is used by the AWS web console to provide search functionality.
    # See: https://github.com/qutebrowser/qutebrowser/issues/6601.
    "concierge.analytics.console.aws.a2z.com",
]


def set_ui_fonts(config: ConfigAPI, size_pt):
    c = config
    c.fonts.default_family = "mononoki Nerd Font Mono"
    c.fonts.default_size = f"{size_pt}pt"
    c.fonts.contextmenu = f"{size_pt + 4}pt sans-serif"


def configure(config: ConfigAPI, c: ConfigContainer):
    if qutebrowser_version >= (2, 0, 0):
        config.load_autoconfig(False)

    if qutebrowser_version >= (2, 0, 2):
        mode_enter = "mode-enter"
    else:
        mode_enter = "enter-mode"

    # Configure ctrl-p to open a fuzzy search prompt for currently open tabs.
    config.bind("<Ctrl-p>", "set-cmd-text -s :tab-select")

    # Configure m to launch `qmpvl`.
    config.bind("m", "hint links spawn " + os.path.join(dotfile_dir, "bin", "i3", "qmpvl") + " {hint-url}")
    config.bind("M", "spawn " + os.path.join(dotfile_dir, "bin", "i3", "qmpvl") + " {url}")

    # Use Shift-Escape to enter passthrough mode instead of Ctrl-V.
    config.bind("<Shift-Escape>", f"{mode_enter} passthrough", mode="normal")
    config.unbind("<Ctrl-V>")

    # Use Ctrl-Shift-J and Ctrl-Shift-K to move tabs down or up, respectively.
    config.bind("<Ctrl-Shift-J>", "tab-move +")
    config.bind("<Ctrl-Shift-K>", "tab-move -")

    # Don't automatically leave insert mode. qutebrowser will leave insert mode automatically
    # if you click off of a textbox element (and under some other conditions) which is kinda
    # annoying.
    config.set("input.insert_mode.auto_leave", False)

    # Don't show history items in completion menu.
    config.set("completion.web_history.max_items", 0)

    config.set("tabs.position", "left")
    config.set("tabs.width", "15%")

    config.set("downloads.position", "bottom")

    # Set default search engine = DuckDuckGo.
    c.url.searchengines["DEFAULT"] = "https://www.duckduckgo.com/?q={}"
    c.url.searchengines["google"] = "https://www.google.com/search?q={}"
    c.url.searchengines["tfawsr"] = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/{}"
    c.url.searchengines["tfawsd"] = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/{}"
    c.url.searchengines["amod"] = "https://docs.ansible.com/ansible/latest/modules/{}_module.html"

    c.url.start_pages = ["about:blank"]

    # On Wayland, setting qt.highdpi does nothing.
    # Additionally, Wayland scaling causes qutebrowser to have an insanely large mouse pointer.
    if display_profile == "UHD":
        if os.environ.get("WAYLAND_DISPLAY", None) is None:
            config.set("qt.highdpi", True)
        else:
            set_ui_fonts(c, 24)
            config.set("zoom.default", 200)
    else:
        set_ui_fonts(c, 10)

    # Fullscreen only fills the qutebrowser window. If we want true fullscreen,
    # we can pair it with the fullscreen offered by i3.
    fullscreen_windowed = True
    if qutebrowser_version < (1, 11, 0):
        # This option was renamed to content.fullscreen.window in qutebrowser v1.11.0.
        config.set("content.windowed_fullscreen", fullscreen_windowed)
    else:
        config.set("content.fullscreen.window", fullscreen_windowed)

    # Per-domain settings. Since qutebrowser currently does not save permission requests
    # for these, we need to include them in our configuration.
    #
    # See https://github.com/qutebrowser/qutebrowser/issues/832.
    for scope, permission_list in url_permissions.items():
        for permission, domains in permission_list.items():
            for d in domains:
                config.set(scope, permission, d)

    for d in url_permissions_media:
        if qutebrowser_version < (1, 14, 0):
            # This option was split into several options for selective audio, video capture in qutebrowser v1.14.0.
            config.set("content.media_capture", True, d)
        else:
            config.set("content.media.audio_capture", True, d)
            config.set("content.media.video_capture", True, d)
            config.set("content.media.audio_video_capture", True, d)
        config.set(content_notifications_enabled, True, d)

    config.set("content.blocking.whitelist", adblock_whitelist_urls)

    config_colors(c)


class Colorscheme:
    """
    Maps colors from our colorscheme onto their intended purpose.
    """

    # A wrapper script at $DOTFILE_DIR/bin/qutebrowser sets these
    # values in the environment for us.
    BG_SHADE_0 = os.environ["COLORSCHEME_BG_SHADE_0"]
    BG_SHADE_1 = os.environ["COLORSCHEME_BG_SHADE_1"]
    BG_SHADE_2 = os.environ["COLORSCHEME_BG_SHADE_2"]
    BG_SHADE_3 = os.environ["COLORSCHEME_BG_SHADE_3"]

    FG_SHADE_0 = os.environ["COLORSCHEME_FG_SHADE_0"]
    FG_SHADE_1 = os.environ["COLORSCHEME_FG_SHADE_1"]
    FG_SHADE_2 = os.environ["COLORSCHEME_FG_SHADE_2"]
    FG_SHADE_3 = os.environ["COLORSCHEME_FG_SHADE_3"]

    BLUE = os.environ["COLORSCHEME_BLUE"]
    RED = os.environ["COLORSCHEME_RED"]
    ORANGE = os.environ["COLORSCHEME_ORANGE"]
    YELLOW = os.environ["COLORSCHEME_YELLOW"]
    GREEN = os.environ["COLORSCHEME_GREEN"]

    ACCENT1_SHADE_0 = os.environ["COLORSCHEME_ACCENT1_SHADE_0"]
    ACCENT1_SHADE_1 = os.environ["COLORSCHEME_ACCENT1_SHADE_1"]
    ACCENT1_SHADE_2 = os.environ["COLORSCHEME_ACCENT1_SHADE_2"]

    ACCENT2_SHADE_0 = os.environ["COLORSCHEME_ACCENT2_SHADE_0"]


def config_colors(c: ConfigContainer):
    # Completion
    c.colors.completion.fg = Colorscheme.FG_SHADE_1

    c.colors.completion.category.border.bottom = Colorscheme.BG_SHADE_0
    c.colors.completion.category.border.top = Colorscheme.BG_SHADE_0
    c.colors.completion.category.bg = Colorscheme.BG_SHADE_0
    c.colors.completion.category.fg = Colorscheme.FG_SHADE_3

    c.colors.completion.item.selected.border.bottom = Colorscheme.FG_SHADE_3
    c.colors.completion.item.selected.border.top = Colorscheme.FG_SHADE_3
    c.colors.completion.item.selected.bg = Colorscheme.BG_SHADE_3
    c.colors.completion.item.selected.fg = Colorscheme.FG_SHADE_3

    c.colors.completion.match.fg = Colorscheme.FG_SHADE_3
    c.colors.completion.even.bg = Colorscheme.BG_SHADE_0
    c.colors.completion.odd.bg = Colorscheme.BG_SHADE_1
    c.colors.completion.scrollbar.bg = Colorscheme.BG_SHADE_0
    c.colors.completion.scrollbar.fg = Colorscheme.FG_SHADE_1

    # Downloads
    c.colors.downloads.bar.bg = Colorscheme.BG_SHADE_0
    c.colors.downloads.error.bg = Colorscheme.RED
    c.colors.downloads.error.fg = Colorscheme.FG_SHADE_3
    c.colors.downloads.start.bg = Colorscheme.GREEN
    c.colors.downloads.start.fg = Colorscheme.FG_SHADE_3

    c.colors.hints.bg = Colorscheme.BG_SHADE_1
    c.colors.hints.fg = Colorscheme.FG_SHADE_1
    c.colors.hints.match.fg = Colorscheme.ORANGE

    c.colors.keyhint.fg = Colorscheme.FG_SHADE_3
    c.colors.keyhint.suffix.fg = Colorscheme.YELLOW

    c.colors.messages.error.bg = Colorscheme.RED
    c.colors.messages.error.border = Colorscheme.RED
    c.colors.messages.error.fg = Colorscheme.FG_SHADE_3

    c.colors.messages.info.bg = Colorscheme.BG_SHADE_0
    c.colors.messages.info.border = Colorscheme.BG_SHADE_0
    c.colors.messages.info.fg = Colorscheme.FG_SHADE_3

    c.colors.messages.warning.bg = Colorscheme.ORANGE
    c.colors.messages.warning.border = Colorscheme.ORANGE
    c.colors.messages.warning.fg = Colorscheme.FG_SHADE_3

    c.colors.prompts.bg = Colorscheme.BG_SHADE_1
    c.colors.prompts.border = "1px solid " + Colorscheme.BG_SHADE_0
    c.colors.prompts.fg = Colorscheme.FG_SHADE_3
    c.colors.prompts.selected.bg = Colorscheme.BG_SHADE_2

    c.colors.statusbar.caret.bg = Colorscheme.BLUE
    c.colors.statusbar.caret.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.caret.selection.bg = Colorscheme.ORANGE
    c.colors.statusbar.caret.selection.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.command.bg = Colorscheme.BG_SHADE_0
    c.colors.statusbar.command.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.insert.bg = Colorscheme.ACCENT1_SHADE_0
    c.colors.statusbar.insert.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.normal.bg = Colorscheme.BG_SHADE_0
    c.colors.statusbar.normal.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.passthrough.bg = Colorscheme.ORANGE
    c.colors.statusbar.passthrough.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.progress.bg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.command.private.bg = Colorscheme.ACCENT1_SHADE_0
    c.colors.statusbar.command.private.fg = Colorscheme.FG_SHADE_2
    c.colors.statusbar.private.bg = Colorscheme.ACCENT1_SHADE_0
    c.colors.statusbar.private.fg = Colorscheme.FG_SHADE_2

    c.colors.statusbar.url.fg = Colorscheme.FG_SHADE_2
    c.colors.statusbar.url.hover.fg = Colorscheme.FG_SHADE_3
    c.colors.statusbar.url.error.fg = Colorscheme.RED
    c.colors.statusbar.url.success.http.fg = Colorscheme.ORANGE
    c.colors.statusbar.url.success.https.fg = Colorscheme.FG_SHADE_2

    ## Foreground color of the URL in the statusbar when there's a warning.
    ## Type: QssColor
    c.colors.statusbar.url.warn.fg = Colorscheme.YELLOW

    c.colors.tabs.bar.bg = Colorscheme.BG_SHADE_0

    c.colors.tabs.even.bg = Colorscheme.BG_SHADE_1
    c.colors.tabs.even.fg = Colorscheme.FG_SHADE_1
    c.colors.tabs.odd.bg = Colorscheme.BG_SHADE_1
    c.colors.tabs.odd.fg = Colorscheme.FG_SHADE_1

    c.colors.tabs.selected.even.bg = Colorscheme.BG_SHADE_2
    c.colors.tabs.selected.even.fg = Colorscheme.FG_SHADE_3
    c.colors.tabs.selected.odd.bg = Colorscheme.BG_SHADE_2
    c.colors.tabs.selected.odd.fg = Colorscheme.FG_SHADE_3

    c.colors.tabs.indicator.error = Colorscheme.RED
    c.colors.tabs.indicator.start = Colorscheme.YELLOW
    c.colors.tabs.indicator.stop = Colorscheme.GREEN


configure(config, c)  # type: ignore[name-defined]
