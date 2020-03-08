# This file defines how displays are used in my workflow.
#
# The primary display is where most focus will be directed.
# The secondary display is where supporting material (e.g. documentation or active chats) go.
# The tertiary display is for additional documentation, Spotify, or perhaps a video that
# is providing some background noise.
if [[ -n "$DISPLAYNAME_CENTER" && -n "$DISPLAYNAME_RIGHT" && -n "$DISPLAYNAME_LEFT" ]]; then
    export DISPLAYNAME_PRIMARY="$DISPLAYNAME_CENTER"
    export DISPLAYNAME_SECONDARY="$DISPLAYNAME_RIGHT"
    export DISPLAYNAME_TERTIARY="$DISPLAYNAME_LEFT"
elif [[ -n "$DISPLAYNAME_CENTER" && -n "$DISPLAYNAME_RIGHT" ]]; then
    export DISPLAYNAME_PRIMARY="$DISPLAYNAME_CENTER"
    export DISPLAYNAME_SECONDARY="$DISPLAYNAME_RIGHT"
    export DISPLAYNAME_TERTIARY="$DISPLAYNAME_SECONDARY"
elif [[ -n "$DISPLAYNAME_CENTER" && -n "$DISPLAYNAME_LEFT" ]]; then
    export DISPLAYNAME_PRIMARY="$DISPLAYNAME_CENTER"
    export DISPLAYNAME_SECONDARY="$DISPLAYNAME_LEFT"
    export DISPLAYNAME_TERTIARY="$DISPLAYNAME_SECONDARY"
elif [[ -n "$DISPLAYNAME_LEFT" && -n "$DISPLAYNAME_RIGHT" ]]; then
    export DISPLAYNAME_PRIMARY="$DISPLAYNAME_RIGHT"
    export DISPLAYNAME_SECONDARY="$DISPLAYNAME_LEFT"
    export DISPLAYNAME_TERTIARY="$DISPLAYNAME_SECONDARY"
fi
