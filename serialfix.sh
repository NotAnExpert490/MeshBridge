#!/bin/bash
echo "Establishing meshvars"
cd ~
meshconf=~/.meshvars
echo 'MT="/dev/ttyACM0"' > "$meshconf"
echo 'MC="/dev/ttyACM1"' > "$meshconf"
echo "Serial configured"
