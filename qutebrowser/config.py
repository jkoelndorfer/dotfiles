# -*- coding: utf-8 -*-

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import os

dotfile_dir = os.environ["DOTFILE_DIR"]
config = config  # type: ConfigAPI # noqa: F821
c = c  # type: ConfigContainer # noqa: F821

# Configure ctrl-p to open a fuzzy search prompt for currently open tabs.
config.bind("<Ctrl-p>", "set-cmd-text -s :buffer")

# Configure m to launch `mpvl`, which launches mpv on the i3 workspace called "video".
config.bind("m", "spawn " + os.path.join(dotfile_dir, "bin", "i3", "qmpvl") + " {url}")

# Don't automatically leave insert mode. qutebrowser will leave insert mode automatically
# if you click off of a textbox element (and under some other conditions) which is kinda
# annoying.
config.set("input.insert_mode.auto_leave", False)

# Set default search engine = google.
c.url.searchengines["DEFAULT"] = "https://www.google.com/search?q={}"

c.fonts.tabs = "10pt mononoki Nerd Font Mono"
c.fonts.monospace = "mononoki Nerd Font Mono"

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
c.colors.statusbar.url.hover.fg = Solarized.BLUE
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
