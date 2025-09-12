#!/bin/bash
set -euo pipefail

echo "Updating and installing Nginx as proxy..."
sudo apt update -y
sudo apt install -y nginx
sudo rm -f /etc/nginx/sites-enabled/default

echo "Starting Nginx configuration..."

cat <<EOF | sudo tee /etc/nginx/sites-available/api
server {
    listen 80;
    server_name api.local;

    location / {
        proxy_pass http://10.0.0.30:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/api /etc/nginx/sites-enabled/api

echo "Testing Nginx configuration..."
sudo nginx -t

echo "Restarting Nginx, applying configurations..."
sudo systemctl restart nginx  
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s 192.168.50.0/24 -o eth0 -j MASQUERADE
sudo DEBIAN_FRONTEND=noninteractive apt install -y nginx iptables-persistent
sudo netfilter-persistent save

echo "Nginx configuration completed and ready to use!"
