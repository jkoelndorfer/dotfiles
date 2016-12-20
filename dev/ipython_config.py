from IPython.lib import deepreload
import sys

c.TerminalInteractiveShell.editing_mode = "vi"

if sys.version_info < (3, 0, 0):
    import __builtin__ as builtins
else:
    import builtins
builtins.reload = deepreload.reload
