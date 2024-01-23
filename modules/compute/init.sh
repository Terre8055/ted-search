#!/bin/bash

# Update the package list
sudo yum update -y

# Install Docker dependencies
sudo yum install -y docker git maven

# Start and enable the Docker service
sudo service docker start
sudo chkconfig docker on

# Add the user to the docker group and start a new shell
sudo usermod -aG docker $(whoami)
# sudo newgrp docker
sudo systemctl restart docker


# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Print Docker and Docker Compose versions
sudo docker --version
sudo docker-compose --version

echo "Docker installation complete."


#AWS CLI

sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

aws ecr get-login-password --region ap-south-1 | sudo sg docker -c 'docker login --username AWS --password-stdin 644435390668.dkr.ecr.ap-south-1.amazonaws.com'


