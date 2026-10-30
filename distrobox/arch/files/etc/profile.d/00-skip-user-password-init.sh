# /etc/profile.d/distrobox_profile.sh will prompt for a user
# password in the distrobox container incessantly if this
# flag is present.
rm -f "/var/tmp/.${USER}.passwd.initialize"
