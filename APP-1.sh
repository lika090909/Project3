#!/bin/bash

sudo yum update -y
sudo yum install -y httpd
sudo systemctl enable httpd
sudo systemctl start httpd
sudo yum install -y wget
sudo wget https://raw.githubusercontent.com/lika090909/Project3/refs/heads/main/birthday-invite.html
sudo cp birthday-invite.html /var/www/html/index.html


