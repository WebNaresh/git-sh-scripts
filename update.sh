#!/bin/bash

# Update package lists
sudo apt update -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install nginx
sudo apt install nginx -y

# Configure nginx
sudo tee /etc/nginx/sites-available/default >/dev/null <<EOF
server {
    root /var/www/html;
    server_name default;

    # Uncomment and configure as needed
    # location /api/ {
    #     proxy_pass http://localhost:4000/;
    #     proxy_http_version 1.1;
    #     proxy_set_header Upgrade \$http_upgrade;
    #     proxy_set_header Connection 'upgrade';
    #     proxy_set_header Host \$host;
    #     proxy_cache_bypass \$http_upgrade;
    # }

    # location / {
    #     root /home/ubuntu/actions-runner-backend-qa/_work/AEGIS-frontend/AEGIS-frontend;
    #     try_files \$uri /index.html;
    # }
}
EOF

# Install pm2 globally
sudo npm install -g pm2

# Set up pm2 startup script
sudo pm2 startup systemd -u ubuntu --hp /home/ubuntu

# Enable the firewall
sudo ufw enable

# Allow SSH, HTTP, and HTTPS through the firewall
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Restart nginx
sudo service nginx restart

# Install Certbot
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get install python3-certbot-nginx -y
