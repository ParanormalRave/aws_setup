#!/bin/bash
set -euo pipefail

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl --connect-timeout 60 --max-time 120 -fsSl https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "You have added docker's official gpg key"

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF
echo "Docker repositories added successfully....."

#installing the Docker packages 

if command -v docker &> dev/null; then
	echo "Docker exists"
else
	echo "Installing docker..."
	sudo apt install docker-ce docker-ce-cli containerd.io -y

fi
if command -v docker-cmpose &> dev/null;then
	echo "Docker compose exists"
else
	echo "installing docker compose......"
	sudo apt install docker-compose-plugin -y
fi
echo "Docker and Docker compose installed successfully"

#updating the software after installation
sudo apt update
echo "Updating the software....."

#managing docker as a non-root user
sudo usermod -aG docker $USER 
newgrp docker
echo "Docker can now run without sudo"

#downloading an image from docker
docker pull nginx
echo" You have downloaded an image from docker"
echo "These are the running containers"
docker ps -a

#creating and starting a container from an image
docker run -d -p 8080:80 --name wordpress-server nginx
echo "you have created and now starting a contianer from an image"

#view running containers
echo "These are the running containers"
docker ps -a



