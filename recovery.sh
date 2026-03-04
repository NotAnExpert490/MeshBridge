#!/bin/bash
if [ -e lockout.txt ]
then
	echo "Max reboot attempt reached. Shutting down"
	rm ~/lockout.txt
	curl -d "Max reboot attempt reached, shutting down.
	./mtsend "Critical error! Shutting down :("
	./mcsend "Critical error! Shutting down :("
	shutdown
else
	echo "Rebooting"
	touch ~/lockout.txt
	curl -d "Rebooting pi in safe mode" notify.dewlab.io/mesh
	./mtsend "Attempting system reboot to safe mode"
	./mcsend "Attempting system reboot to safe mode"
	reboot
fi
