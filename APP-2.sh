#!/bin/bash

sudo yum update -y
sudo yum install -y httpd wget

# Create app1 directory under web root
sudo mkdir -p /var/www/html/app2

# Download the HTML file as index.html inside /app1
sudo wget -O /var/www/html/app2/index.html  https://raw.githubusercontent.com/lika090909/Project3/refs/heads/main/movie-ranking.html

# Create welcome.html directly in web root (for /welcome)
echo '<h1>Welcome to My Website APP-2</h1>' | sudo tee /var/www/html/app2/welcome

# Restart Apache
sudo systemctl enable httpd
sudo systemctl restart httpd

# Save instance metadata for debugging under /app1 (optional)
TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/app2/metadata
