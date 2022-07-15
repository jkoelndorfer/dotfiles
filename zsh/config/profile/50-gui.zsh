# Time, in seconds, before xss-lock will lock the screen.
export SCREENLOCK_TIME_SECONDS=$((15 * 60))

# Maximum time, in seconds, that the screen can be locked and
# still resume music if there was any playing.
#
# This will keep Spotify from playing music on the Echo speakers
# at home when I show up at the office in the morning.
export SCREENLOCK_MUSIC_RESUME_TIME_SECONDS=1200

# Time, in seconds, after which the mouse cursor will be hidden
# if the mouse is not moved.
export CURSOR_HIDE_TIME_SECONDS=5

export DESKTOP_THEME='nord'
