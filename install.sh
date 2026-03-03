#!/bin/bash
echo "Updating pi"
sudo apt-get install locales-all
sudo apt update
sudo apt upgrade -y
cd ~
echo "Installing node-red"
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/update-nodejs-and-nodered-deb) --nodered-user=$USER --confirm-install --confirm-pi
cd ~
echo "Installing mosquitto"
sudo apt install mosquitto mosquitto-clients -y
echo "Enabling node-red service"
echo "Copying flow"
cp ~/MeshBridge/flows.json ~/.node-red/
sudo systemctl enable nodered.service
echo "Enabling mosquitto service"
sudo systemctl enable mosquitto
cd ~
echo "Installing python"
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install pipx -y
sudo apt update
echo "Installing meshcore-cli"
pipx install meshcore-cli
cd ~
echo "Installing meshtastic-cli"
pipx install "meshtastic[cli]"
pipx ensurepath
echo "Finding meshcore port"
cd ~
meshconf=~/.meshvars
if [meshcli -s /dev/ttyACM0 sync_msgs ]
then
echo "Meshcore found on /dev/ttyACM0"
echo 'MC="/dev/ttyACM0"' > "$testfile"
echo 'MT="/dev/ttyACM1"' > "$testfile"
else
echo 'MT="/dev/ttyACM0"' > "$testfile"
echo 'MC="/dev/ttyACM1"' > "$testfile"
fi
echo "Serial configured"
echo "Copying scripts to $HOME"
cp ~/MeshBridge/mtsend.sh ~/
cp ~/MeshBridge/mcsend.sh ~/
cp ~/MeshBridge/mcread.sh ~/
cp ~/MeshBridge/recovery.sh ~/
echo "Done!"
echo "Rebooting"
#sudo reboot

