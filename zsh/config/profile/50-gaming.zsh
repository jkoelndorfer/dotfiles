source "${DOTFILE_DIR}/zsh/lib/system.zsh"

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# Store DXVK state cache in a consistent location.
# See https://github.com/doitsujin/dxvk#state-cache.
export DXVK_STATE_CACHE_PATH="${HOME}/.cache/dxvk"

# Enable wine-staging's shared memory feature.
# See https://wiki.winehq.org/Wine-Staging_Environment_Variables.
export STAGING_SHARED_MEMORY=1

# If running on an atomic Linux host, set STEAM_LIBRARY_ROOT
# to the path used by the Steam flatpak.
if is-atomic-linux-host; then
  export STEAM_LIBRARY_ROOT="${HOME}/.var/app/com.valvesoftware.Steam/.steam/steam"
fi
