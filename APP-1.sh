#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo sed 's/DirectoryIndex index.html/DirectoryIndex invite.html/' /etc/httpd/conf/httpd.conf > /tmp/httpd.conf
sudo mv /tmp/httpd.conf /etc/httpd/conf/httpd.conf
sudo systemctl enable httpd
sudo systemctl restart httpd
sudo yum install -y wget


sudo wget -O /var/www/html/invite.html https://raw.githubusercontent.com/lika090909/Project3/main/birthday-invite.html

sudo echo '<h1>Welcome to My Website</h1>' | sudo tee /var/www/html/welcome
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
sudo curl -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document -o /var/www/html/metadata
