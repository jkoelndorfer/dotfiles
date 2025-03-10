source "${DOTFILE_DIR}/shell/lib/system.sh"

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

# Store DXVK state cache in a consistent location.
# See https://github.com/doitsujin/dxvk#state-cache.
export DXVK_STATE_CACHE_PATH="${HOME}/.cache/dxvk"

# Enable wine-staging's shared memory feature.
# See https://wiki.winehq.org/Wine-Staging_Environment_Variables.
export STAGING_SHARED_MEMORY=1

# If running on an atomic Linux host, set STEAM_HOME to the path
# used by the Steam flatpak.
if is-atomic-linux-host; then
  export STEAM_HOME="${HOME}/.var/app/com.valvesoftware.Steam"
fi
