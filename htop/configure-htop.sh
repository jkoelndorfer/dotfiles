#!/bin/bash

# htop rewrites its configuration file on every run, so we don't just
# configure a simple symlink. Instead, we deploy our settings when the
# dotfile installation script is run.

htop_rc="$HOME/.config/htop/htoprc"
mkdir -p "$(dirname "$htop_rc")"

# Colorscheme 6 is "broken gray" which works better with Solarized Dark.
# See https://github.com/hishamhm/htop/pull/144.
cat > "$htop_rc" <<'EOF'
fields=0 48 17 18 38 39 40 2 46 47 49 1
sort_key=46
sort_direction=1
hide_threads=0
hide_kernel_threads=1
hide_userland_threads=0
shadow_other_users=0
show_thread_names=0
show_program_path=1
highlight_base_name=0
highlight_megabytes=1
highlight_threads=1
tree_view=0
header_margin=1
detailed_cpu_time=1
cpu_count_from_zero=0
update_process_names=0
account_guest_in_cpu_meter=0
color_scheme=6
delay=15
left_meters=LeftCPUs2 CPU CPU Tasks LoadAverage
left_meter_modes=1 1 2 2 2
right_meters=RightCPUs2 Memory Swap Uptime
right_meter_modes=1 1 2 2
EOF
