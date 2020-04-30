# -*- coding: utf-8 -*-

from qutebrowser import __version_info__ as qutebrowser_version  # tuple like (1, 11, 0)
from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import os

def set_ui_fonts(config, size_pt):
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

dotfile_dir = os.environ["DOTFILE_DIR"]
display_profile = os.environ["DISPLAY_PROFILE"]
config = config  # type: ConfigAPI # noqa: F821
c = c  # type: ConfigContainer # noqa: F821

# Configure ctrl-p to open a fuzzy search prompt for currently open tabs.
config.bind("<Ctrl-p>", "set-cmd-text -s :buffer")

# Configure m to launch `qmpvl`.
config.bind("m", "hint links spawn " + os.path.join(dotfile_dir, "bin", "i3", "qmpvl") + " {hint-url}")
config.bind("M", "spawn " + os.path.join(dotfile_dir, "bin", "i3", "qmpvl") + " {url}")

# Use Shift-Escape to enter passthrough mode instead of Ctrl-V.
config.bind("<Shift-Escape>", "enter-mode passthrough", mode="normal")
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

# Set default search engine = google.
c.url.searchengines["DEFAULT"] = "https://www.google.com/search?q={}"
for t in ("wowhead", "wh"):
    c.url.searchengines[t] = "https://classic.wowhead.com/search?q={}"
for t in ("bbg", "auc", "auction"):
    c.url.searchengines[t] = "https://www.bootybaygazette.com/#us/thunderfury-a/search/{}"

# Set start page = google.com
c.url.start_pages = ["https://www.google.com"]

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

# Needed for mailto: links.
config.set("content.register_protocol_handler", True, "https://mail.google.com/*")

# Needed for webcal links.
config.set("content.register_protocol_handler", True, "https://calendar.google.com/*")

# Allow popups for my bank's online portal.
config.set("content.javascript.can_open_tabs_automatically", True, "https://www.financial-net.com/*")

config.set("content.notifications", True, "https://mail.google.com/*")
config.set("content.media_capture", True, "https://mail.google.com")
config.set("content.media_capture", True, "https://hangouts.google.com")

config.set("content.media_capture", True, "https://*.slack.com")
config.set("content.notifications", True, "https://*.slack.com")


################
# COLOR SCHEME #
################

# A wrapper script at $DOTFILE_DIR/bin/qutebrowser sets these
# values for us.
class Solarized:
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

# flake8: noqa: E221
