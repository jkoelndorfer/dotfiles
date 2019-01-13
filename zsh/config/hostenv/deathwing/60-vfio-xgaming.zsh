# Path to the HDMI switch device.
export HDMI_SWITCH_DEVICE_PATH='/dev/ttyUSB0'

# The xrandr display name of the monitor used for gaming. It will
# have the more powerful GPU hooked up to it through the programmable
# HDMI switch.
export GAMING_MONITOR_DISPLAYNAME='HDMI-1'

# The name of one of the displays that the gaming monitor is adjacent to.
# Used in combination with GAMING_MONITOR_RELATIVE_POSITION below.
export GAMING_MONITOR_RELATIVE_DISPLAYNAME='DVI-D-1'

# Position of gaming monitor relative to GAMING_MONITOR_RELATIVE_DISPLAYNAME
# Could be "left-of" or "right-of", or another keyword supported by xrandr.
export GAMING_MONITOR_RELATIVE_POSITION='right-of'

# Input number of the primary input on the programmable HDMI switch.
# This is the normal mode where the gaming GPU is not used.
export HDMI_SWITCH_PRIMARY_HDMI_INPUT=1

# Input number of the high-end GPU on the programmable HDMI switch.
# This is used for GPU passthrough with VFIO or when launching
# a separate X server for gaming.
export HDMI_SWITCH_ACCELERATED_HDMI_INPUT=2

# Input number used for miscellaneous external sources on the
# programmable HDMI switch.
export HDMI_SWITCH_EXTERNAL_HDMI_INPUT=4

# Name of the Xorg keyboard device.
export X11_KEYBOARD_DEVICE='Logitech Gaming Keyboard G810'

# Name of the Xorg mouse device.
export X11_MOUSE_DEVICE='SteelSeries SteelSeries Rival 700 Gaming Mouse'

# Primary Xorg display.
# TODO: We should autodetect this on login. It's slightly brittle when
# hardcoded.
export PRIMARY_DISPLAY=':0'

# Xorg display used for gaming.
export GAMING_DISPLAY=':10'

# Name of the screen in Synergy used for gaming.
export SYNERGY_GAMING_SCREEN='deathwing-gaming'

# PCI device address of the high-end GPU.
export HIGH_END_GPU_PCI_ADDRESS='0000:03:00.0'
export HIGH_END_GPU_AUDIO_PCI_ADDRESS='0000:03:00.1'
