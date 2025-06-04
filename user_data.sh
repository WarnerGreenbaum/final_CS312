#!/bin/bash
set -e  # Exit immediately if any command fails

# Server setup source: https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server

# install java and update dependencies
apt-get update
apt-get install -y openjdk-17-jdk screen

# create mineraft user
useradd -m -d /opt/minecraft -s /bin/bash minecraft || echo "User already exists"

# create minecraft directory
sudo -u minecraft mkdir -p /opt/minecraft/server
cd /opt/minecraft/server

# download the server jar
sudo -u minecraft wget -q https://piston-data.mojang.com/v1/objects/8dd1a28015f51b1803213892b50b7b4fc76e594d/server.jar

# run the file first, for auto accepting the EULA
sudo -u minecraft java -Xmx1G -Xms1G -jar server.jar nogui || true

# Auto accept EULA
sudo -u minecraft sed -i 's/eula=false/eula=true/' eula.txt

# random server configuration
cat <<EOF | sudo -u minecraft tee -a server.properties
difficulty=normal
gamemode=survival
max-players=69
motd=Minecraft Server
EOF

# Systemd creation sources: https://bbs.archlinux.org/viewtopic.php?id=221496 and https://minecraft.fandom.com/wiki/Tutorials/Server_startup_script

# create systemd service for restarting the server automatically
cat <<EOF > /etc/systemd/system/minecraft.service
[Unit]
Description=Minecraft Server
After=network.target

[Service]
User=minecraft
WorkingDirectory=/opt/minecraft/server
ExecStart=/usr/bin/java -Xmx2G -Xms1G -jar server.jar nogui
Restart=always
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# enabling and starting the service.
systemctl daemon-reload
systemctl enable minecraft.service
systemctl restart minecraft.service
