#!/bin/bash
set -euxo pipefail
exec > >(tee -a /var/log/user-data.log) 2>&1

yum -y update
yum -y install wget
yum -y install java-11-amazon-corretto
sudo dnf -y install mariadb105


mkdir -p /home/ec2-user/app3
chown ec2-user:ec2-user /home/ec2-user/app3

# download WAR with retries (needs NAT if in private subnets)
for i in {1..5}; do
  wget -O /home/ec2-user/app3/usermgmt-webapp.war \
    https://github.com/stacksimplify/temp1/releases/download/1.0.0/usermgmt-webapp.war && break || sleep 5
done


export DB_ENDPOINT=${db_endpoint}  
export DB_NAME=webappdb
export DB_USERNAME=dbadmin
export DB_PASSWORD=dbpassword11


# Spring Boot datasource (endpoint already has :port; require SSL)
export SPRING_DATASOURCE_URL="jdbc:mysql://$${DB_ENDPOINT}/$${DB_NAME}?sslMode=REQUIRED&serverTimezone=UTC"
export SPRING_DATASOURCE_USERNAME="$${DB_USERNAME}"
export SPRING_DATASOURCE_PASSWORD="$${DB_PASSWORD}"

# run on 8080 to match your TG
nohup java -jar /home/ec2-user/app3/usermgmt-webapp.war \
  --server.port=8080 \
  > /home/ec2-user/app3/ums-start.log 2>&1 &
