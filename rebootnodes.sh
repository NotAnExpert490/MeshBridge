#!/bin/bash
source ~/.meshvars
~/.local/bin/meshcli -s $MC reboot
~/.local/bin/meshtastic --host meshtastic.local --reboot
