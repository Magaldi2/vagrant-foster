#!/bin/bash
set -euo pipefail

echo "Updating packages..."
sudo apt update -y --fix-missing
sudo apt upgrade -y --fix-missing


echo "Installing dependencies..."
sudo apt install -y gnupg curl

echo "Importing MongoDB key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg --dearmor

echo "Adding MongoDB repository..."
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/8.0 multiverse" | \
   sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list

echo "Installing MongoDB..."
sudo apt update -y
sudo apt install -y mongodb-org

echo "Enabling and starting MongoDB service..."
sudo systemctl enable mongod
sudo systemctl start mongod

echo "MongoDB installation and startup completed ✅"
