# flake8: noqa: E221

from qutebrowser import __version_info__ as qutebrowser_version  # tuple like (1, 11, 0)
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import os
from typing import Dict, List

dotfile_dir = os.environ["DOTFILE_DIR"]
display_profile = os.environ["DISPLAY_PROFILE"]

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
        False: [
        ],
    },

    "content.javascript.can_open_tabs_automatically": {
        True: [
            # Allow popups for my bank's online portal.
            "https://www.financial-net.com/*",
        ],
        False: [
        ],
    },

    content_notifications_enabled: {
        True: [
        ],
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
    font_completion = (c.fonts.completion, ["category", "entry"])
    font_messages = (c.fonts.messages, ["error", "info", "warning"])
    fonts = (c.fonts, [
        "debug_console",
        "downloads",
        "hints",
        "keyhint",
        "prompts",
        "statusbar",
        "tabs",
    ])

    for obj, attrs in [font_completion, font_messages, fonts]:
        for attr in attrs:
            setattr(obj, attr, "{}pt monospace".format(size_pt))


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
    c.url.searchengines["tfawsr"] = "https://www.terraform.io/docs/providers/aws/r/{}.html"
    c.url.searchengines["tfawsd"] = "https://www.terraform.io/docs/providers/aws/d/{}.html"
    c.url.searchengines["amod"] = "https://docs.ansible.com/ansible/latest/modules/{}_module.html"

    c.url.start_pages = ["about:blank"]

    try:
        # default_family replaces monospace as of qutebrowser v1.10
        c.fonts.default_family = "mononoki Nerd Font Mono"
    except Exception:
        c.fonts.monospace = "mononoki Nerd Font Mono"
        set_ui_fonts(c, 10)

    if display_profile == "UHD":
        config.set("qt.highdpi", True)

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


class Solarized:
    """
    Contains the Solarized color palette.
    """
    # A wrapper script at $DOTFILE_DIR/bin/qutebrowser sets these
    # values in the environment for us.
    BASE00  = os.environ["SOLARIZED_BASE00"]
    BASE01  = os.environ["SOLARIZED_BASE01"]
    BASE02  = os.environ["SOLARIZED_BASE02"]
    BASE03  = os.environ["SOLARIZED_BASE03"]
    BASE0   = os.environ["SOLARIZED_BASE0"]
    BASE1   = os.environ["SOLARIZED_BASE1"]
    BASE2   = os.environ["SOLARIZED_BASE2"]
    BASE3   = os.environ["SOLARIZED_BASE3"]
    YELLOW  = os.environ["SOLARIZED_YELLOW"]
    ORANGE  = os.environ["SOLARIZED_ORANGE"]
    RED     = os.environ["SOLARIZED_RED"]
    MAGENTA = os.environ["SOLARIZED_MAGENTA"]
    VIOLET  = os.environ["SOLARIZED_VIOLET"]
    BLUE    = os.environ["SOLARIZED_BLUE"]
    CYAN    = os.environ["SOLARIZED_CYAN"]
    GREEN   = os.environ["SOLARIZED_GREEN"]


def config_colors(c: ConfigContainer):
    # Completion
    c.colors.completion.fg = Solarized.BASE1

    c.colors.completion.category.border.bottom = Solarized.BASE03
    c.colors.completion.category.border.top = Solarized.BASE03
    c.colors.completion.category.bg = Solarized.BASE03
    c.colors.completion.category.fg = Solarized.BASE3

    c.colors.completion.item.selected.border.bottom = Solarized.BASE1
    c.colors.completion.item.selected.border.top = Solarized.BASE1
    c.colors.completion.item.selected.bg = Solarized.BASE1
    c.colors.completion.item.selected.fg = Solarized.BASE3

    c.colors.completion.match.fg = Solarized.BASE3
    c.colors.completion.even.bg = Solarized.BASE03
    c.colors.completion.odd.bg = Solarized.BASE02
    c.colors.completion.scrollbar.bg = Solarized.BASE03
    c.colors.completion.scrollbar.fg = Solarized.BASE1

    # Downloads
    c.colors.downloads.bar.bg = Solarized.BASE03
    c.colors.downloads.error.bg = Solarized.RED
    c.colors.downloads.error.fg = Solarized.BASE3
    c.colors.downloads.start.fg = Solarized.BASE3

    c.colors.hints.bg = Solarized.BASE02
    c.colors.hints.fg = Solarized.BASE1
    c.colors.hints.match.fg = Solarized.ORANGE

    c.colors.keyhint.fg = Solarized.BASE3
    c.colors.keyhint.suffix.fg = Solarized.YELLOW

    c.colors.messages.error.bg = Solarized.RED
    c.colors.messages.error.border = Solarized.RED
    c.colors.messages.error.fg = Solarized.BASE3

    c.colors.messages.info.bg = Solarized.BASE03
    c.colors.messages.info.border = Solarized.BASE03
    c.colors.messages.info.fg = Solarized.BASE3

    c.colors.messages.warning.bg = Solarized.ORANGE
    c.colors.messages.warning.border = Solarized.ORANGE
    c.colors.messages.warning.fg = Solarized.BASE3

    c.colors.prompts.bg = Solarized.BASE02
    c.colors.prompts.border = '1px solid ' + Solarized.BASE03
    c.colors.prompts.fg = Solarized.BASE3
    c.colors.prompts.selected.bg = Solarized.BASE01

    c.colors.statusbar.caret.bg = Solarized.BLUE
    c.colors.statusbar.caret.fg = Solarized.BASE2

    c.colors.statusbar.caret.selection.bg = Solarized.MAGENTA
    c.colors.statusbar.caret.selection.fg = Solarized.BASE2

    c.colors.statusbar.command.bg = Solarized.BASE03
    c.colors.statusbar.command.fg = Solarized.BASE2

    c.colors.statusbar.insert.bg = Solarized.YELLOW
    c.colors.statusbar.insert.fg = Solarized.BASE2

    c.colors.statusbar.normal.bg = Solarized.BASE03
    c.colors.statusbar.normal.fg = Solarized.BASE2

    c.colors.statusbar.passthrough.bg = Solarized.ORANGE
    c.colors.statusbar.passthrough.fg = Solarized.BASE2

    c.colors.statusbar.progress.bg = Solarized.BASE2

    c.colors.statusbar.command.private.bg = Solarized.VIOLET
    c.colors.statusbar.command.private.fg = Solarized.BASE2
    c.colors.statusbar.private.bg = Solarized.VIOLET
    c.colors.statusbar.private.fg = Solarized.BASE2

    c.colors.statusbar.url.fg = Solarized.BASE2
    c.colors.statusbar.url.hover.fg = Solarized.BASE3
    c.colors.statusbar.url.error.fg = Solarized.RED
    c.colors.statusbar.url.success.http.fg = Solarized.ORANGE
    c.colors.statusbar.url.success.https.fg = Solarized.BASE2

    ## Foreground color of the URL in the statusbar when there's a warning.
    ## Type: QssColor
    c.colors.statusbar.url.warn.fg = Solarized.YELLOW

    c.colors.tabs.bar.bg = Solarized.BASE03
    c.colors.tabs.even.bg = Solarized.BASE02
    c.colors.tabs.even.fg = Solarized.BASE1

    c.colors.tabs.indicator.error = Solarized.RED
    c.colors.tabs.indicator.start = Solarized.YELLOW
    c.colors.tabs.indicator.stop = Solarized.GREEN

    c.colors.tabs.odd.bg = Solarized.BASE02
    c.colors.tabs.odd.fg = Solarized.BASE1

    c.colors.tabs.selected.even.bg = Solarized.BASE01
    c.colors.tabs.selected.even.fg = Solarized.BASE3

    c.colors.tabs.selected.odd.bg = Solarized.BASE01
    c.colors.tabs.selected.odd.fg = Solarized.BASE3

configure(config, c)  # type: ignore[name-defined]
