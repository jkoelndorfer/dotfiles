#!/bin/bash

if [[ "$(uname)" != 'Linux' ]]; then
    exit 0
fi

systemctl --user disable dunst.service
systemctl --user mask dunst.service
