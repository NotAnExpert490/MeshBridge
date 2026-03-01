!/bin/bash
echo "Creating user mesh with password bridge."
echo "It's recommended to change this password using sudo usermod -p <your_password> mesh"
sudo adduser --disabled-password mesh
sudo usermod -aG sudo mesh
su - mesh
sudo usermod -p bridge mesh
echo "Updating pi"
sudo apt update
sudo apt upgrade -y
cd ~
echo "Installing node-red"
bash <(curl -sL https://github.com/node-red/linux-installers/releases/latest/download/update-nodejs-and-nodered-deb)
cd ~
echo "Installing mosquitto"
sudo apt install mosquitto mosquitto-clients -y
echo "Enabling node-red service"
sudo systemctl enable nodered.service
sudo systemctl stop nodered.service
curl -X POST http://localhost:1880/flows \
-H "Content-Type: application/json" \
--data-binary ~/MeshBridge/meshflow.json
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

