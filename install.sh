#!/bin/bash

# Update package lists
sudo apt-get update

# Install ffuf
echo "Installing ffuf..."
sudo apt-get install -y ffuf

# Install gobuster
echo "Installing gobuster..."
sudo apt-get install -y gobuster

# Install dirb
echo "Installing dirb..."
sudo apt-get install -y dirb

# Install amass
echo "Installing amass..."
sudo snap install amass

# Install nuclei
echo "Installing nuclei..."
GO111MODULE=on go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei

# Install nmap
echo "Installing nmap..."
sudo apt-get install -y nmap

echo "All tools installed successfully."