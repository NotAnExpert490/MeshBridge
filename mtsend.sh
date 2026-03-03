#!/bin/bash
~/.local/bin/meshtastic --serial $MT --ch-index 1 --sendtext "$*"
