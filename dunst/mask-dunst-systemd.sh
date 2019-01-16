#!/bin/bash

systemctl --user disable dunst.service
systemctl --user mask dunst.service
