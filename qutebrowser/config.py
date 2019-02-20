# -*- coding: utf-8 -*-

from qutebrowser.config.configfiles import ConfigAPI
from qutebrowser.config.config import ConfigContainer

import os

config = config  # type: ConfigAPI # noqa: F821
c = c  # type: ConfigContainer # noqa: F821

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


class ColorScheme:
    UNSELECTED_TABS_BG = Solarized.BASE02
    UNSELECTED_TABS_FG = Solarized.BASE2
    SELECTED_TAB_BG = Solarized.BASE01
    SELECTED_TAB_FG = Solarized.BASE2

c.url.searchengines["DEFAULT"] = "https://www.google.com/search?q={}"

c.fonts.tabs = "10pt mononoki Nerd Font Mono"
c.fonts.monospace = "mononoki Nerd Font Mono"

## Background color of the completion widget category headers.
c.colors.completion.category.bg = Solarized.BASE03

## Bottom border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.bottom = Solarized.BASE03

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.category.border.top = Solarized.BASE03

## Foreground color of completion widget category headers.
## Type: QtColor
c.colors.completion.category.fg = Solarized.BASE3

## Background color of the completion widget for even rows.
## Type: QssColor
c.colors.completion.even.bg = Solarized.BASE02

## Text color of the completion widget.
## Type: QtColor
c.colors.completion.fg = Solarized.BASE3

## Background color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.bg = Solarized.VIOLET

## Bottom border color of the selected completion item.
## Type: QssColor
c.colors.completion.item.selected.border.bottom = Solarized.VIOLET

## Top border color of the completion widget category headers.
## Type: QssColor
c.colors.completion.item.selected.border.top = Solarized.VIOLET

## Foreground color of the selected completion item.
## Type: QtColor
c.colors.completion.item.selected.fg = Solarized.BASE3

## Foreground color of the matched text in the completion.
## Type: QssColor
c.colors.completion.match.fg = Solarized.BASE2

## Background color of the completion widget for odd rows.
## Type: QssColor
c.colors.completion.odd.bg = Solarized.BASE02

## Color of the scrollbar in completion view
## Type: QssColor
c.colors.completion.scrollbar.bg = Solarized.BASE0

## Color of the scrollbar handle in completion view.
## Type: QssColor
c.colors.completion.scrollbar.fg = Solarized.BASE2

## Background color for the download bar.
## Type: QssColor
c.colors.downloads.bar.bg = Solarized.BASE03

## Background color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.bg = Solarized.RED

## Foreground color for downloads with errors.
## Type: QtColor
c.colors.downloads.error.fg = Solarized.BASE3

## Color gradient start for download backgrounds.
## Type: QtColor
# c.colors.downloads.start.bg = '#0000aa'

## Color gradient start for download text.
## Type: QtColor
c.colors.downloads.start.fg = Solarized.BASE3

## Color gradient stop for download backgrounds.
## Type: QtColor
# c.colors.downloads.stop.bg = '#00aa00'

## Color gradient end for download text.
## Type: QtColor
# c.colors.downloads.stop.fg = solarized['base3']

## Color gradient interpolation system for download backgrounds.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.downloads.system.bg = 'rgb'

## Color gradient interpolation system for download text.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.downloads.system.fg = 'rgb'

## Background color for hints. Note that you can use a `rgba(...)` value
## for transparency.
## Type: QssColor
c.colors.hints.bg = Solarized.VIOLET

## Font color for hints.
## Type: QssColor
c.colors.hints.fg = Solarized.BASE3

## Font color for the matched part of hints.
## Type: QssColor
c.colors.hints.match.fg = Solarized.BASE2

## Background color of the keyhint widget.
## Type: QssColor
# c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'

## Text color for the keyhint widget.
## Type: QssColor
c.colors.keyhint.fg = Solarized.BASE3

## Highlight color for keys to complete the current keychain.
## Type: QssColor
c.colors.keyhint.suffix.fg = Solarized.YELLOW

## Background color of an error message.
## Type: QssColor
c.colors.messages.error.bg = Solarized.RED

## Border color of an error message.
## Type: QssColor
c.colors.messages.error.border = Solarized.RED

## Foreground color of an error message.
## Type: QssColor
c.colors.messages.error.fg = Solarized.BASE3

## Background color of an info message.
## Type: QssColor
c.colors.messages.info.bg = Solarized.BASE03

## Border color of an info message.
## Type: QssColor
c.colors.messages.info.border = Solarized.BASE03

## Foreground color an info message.
## Type: QssColor
c.colors.messages.info.fg = Solarized.BASE3

## Background color of a warning message.
## Type: QssColor
c.colors.messages.warning.bg = Solarized.ORANGE

## Border color of a warning message.
## Type: QssColor
c.colors.messages.warning.border = Solarized.ORANGE

## Foreground color a warning message.
## Type: QssColor
c.colors.messages.warning.fg = Solarized.BASE3

## Background color for prompts.
## Type: QssColor
c.colors.prompts.bg = Solarized.BASE02

## Border used around UI elements in prompts.
## Type: String
c.colors.prompts.border = '1px solid ' + Solarized.BASE03

## Foreground color for prompts.
## Type: QssColor
c.colors.prompts.fg = Solarized.BASE3

## Background color for the selected item in filename prompts.
## Type: QssColor
c.colors.prompts.selected.bg = Solarized.BASE01

## Background color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.bg = Solarized.BLUE

## Foreground color of the statusbar in caret mode.
## Type: QssColor
c.colors.statusbar.caret.fg = Solarized.BASE3

## Background color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.bg = Solarized.VIOLET

## Foreground color of the statusbar in caret mode with a selection.
## Type: QssColor
c.colors.statusbar.caret.selection.fg = Solarized.BASE3

## Background color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.bg = Solarized.BASE03

## Foreground color of the statusbar in command mode.
## Type: QssColor
c.colors.statusbar.command.fg = Solarized.BASE3

## Background color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.bg = Solarized.BASE01

## Foreground color of the statusbar in private browsing + command mode.
## Type: QssColor
c.colors.statusbar.command.private.fg = Solarized.BASE3

## Background color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.bg = Solarized.GREEN

## Foreground color of the statusbar in insert mode.
## Type: QssColor
c.colors.statusbar.insert.fg = Solarized.BASE3

## Background color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.bg = Solarized.BASE03

## Foreground color of the statusbar.
## Type: QssColor
c.colors.statusbar.normal.fg = Solarized.BASE3

## Background color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.bg = Solarized.MAGENTA

## Foreground color of the statusbar in passthrough mode.
## Type: QssColor
c.colors.statusbar.passthrough.fg = Solarized.BASE3

## Background color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.bg = Solarized.BASE01

## Foreground color of the statusbar in private browsing mode.
## Type: QssColor
c.colors.statusbar.private.fg = Solarized.BASE3

## Background color of the progress bar.
## Type: QssColor
c.colors.statusbar.progress.bg = Solarized.BASE3

## Foreground color of the URL in the statusbar on error.
## Type: QssColor
c.colors.statusbar.url.error.fg = Solarized.RED

## Default foreground color of the URL in the statusbar.
## Type: QssColor
c.colors.statusbar.url.fg = Solarized.BASE3

## Foreground color of the URL in the statusbar for hovered links.
## Type: QssColor
c.colors.statusbar.url.hover.fg = Solarized.BASE2

## Foreground color of the URL in the statusbar on successful load
## (http).
## Type: QssColor
c.colors.statusbar.url.success.http.fg = Solarized.BASE3

## Foreground color of the URL in the statusbar on successful load
## (https).
## Type: QssColor
c.colors.statusbar.url.success.https.fg = Solarized.BASE3

## Foreground color of the URL in the statusbar when there's a warning.
## Type: QssColor
c.colors.statusbar.url.warn.fg = Solarized.YELLOW

## Background color of the tab bar.
## Type: QtColor
c.colors.tabs.bar.bg = Solarized.BASE03

## Background color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.bg = ColorScheme.UNSELECTED_TABS_BG

## Foreground color of unselected even tabs.
## Type: QtColor
c.colors.tabs.even.fg = ColorScheme.UNSELECTED_TABS_FG

## Color for the tab indicator on errors.
## Type: QtColor
c.colors.tabs.indicator.error = Solarized.RED

## Color gradient start for the tab indicator.
## Type: QtColor
c.colors.tabs.indicator.start = Solarized.VIOLET

## Color gradient end for the tab indicator.
## Type: QtColor
c.colors.tabs.indicator.stop = Solarized.ORANGE

## Color gradient interpolation system for the tab indicator.
## Type: ColorSystem
## Valid values:
##   - rgb: Interpolate in the RGB color system.
##   - hsv: Interpolate in the HSV color system.
##   - hsl: Interpolate in the HSL color system.
##   - none: Don't show a gradient.
# c.colors.tabs.indicator.system = 'rgb'

## Background color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.bg = ColorScheme.UNSELECTED_TABS_BG

## Foreground color of unselected odd tabs.
## Type: QtColor
c.colors.tabs.odd.fg = ColorScheme.UNSELECTED_TABS_FG

## Background color of selected even tabs.
## Type: QtColor
c.colors.tabs.selected.even.bg = ColorScheme.SELECTED_TAB_BG

## Foreground color of selected even tabs.
## Type: QtColor
c.colors.tabs.selected.even.fg = ColorScheme.SELECTED_TAB_FG

## Background color of selected odd tabs.
## Type: QtColor
c.colors.tabs.selected.odd.bg = ColorScheme.SELECTED_TAB_BG

## Foreground color of selected odd tabs.
## Type: QtColor
c.colors.tabs.selected.odd.fg = ColorScheme.SELECTED_TAB_FG

## Background color for webpages if unset (or empty to use the theme's
## color)
## Type: QtColor
# c.colors.webpage.bg = 'white'

# flake8: noqa: E221
