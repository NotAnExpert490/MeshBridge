#!/bin/bash
source ~/.meshvars
~/.local/bin/meshtastic --host meshtastic.local --ch-index 1 --sendtext "$*"
