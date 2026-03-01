!/bin/bash
echo "Updating pi"
sudo apt update
sudo apt upgrade -y
cd ~
echo "Installing node-red"
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/update-nodejs-and-nodered-deb) --confirm-root --confirm-install --confirm-pi
cd ~
echo "Installing mosquitto"
sudo apt install mosquitto mosquitto-clients -y
echo "Enabling node-red service"
sudo systemctl enable nodered.service
sudo systemctl stop nodered.service
echo "Copying flow"
echo sudo cp ~/MeshBridge/flows.json ~/.node-red/
sudo systemctl start nodered.service
echo "Enabling mosquitto service"
sudo systemctl enable mosquitto
cd ~
echo "Installing python"
sudo apt install python3-pip -y
sudo apt install pipx -y
echo "Installing meshcore-cli"
sudo pipx install meshcore-cli
cd ~
echo "Installing meshtastic-cli"
sudo pipx install "meshtastic[cli]"
sudo reboot

