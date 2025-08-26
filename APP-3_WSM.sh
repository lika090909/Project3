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


TOKEN=$(curl -sS -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
REGION=$(curl -sS -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

SECRET_ID="arn:aws:secretsmanager:us-east-1:058264231384:secret:dev/database_creds-SKaLIi"

for i in {1..6}; do
  SECRET_JSON=$(aws secretsmanager get-secret-value \
    --region "$REGION" \
    --secret-id "$SECRET_ID" \
    --query SecretString --output text 2>/dev/null) && break
  echo "Waiting for Secrets Manager…"
  sleep 5
done

  
export DB_ENDPOINT=$(echo "$SECRET_JSON" | jq -r .host)
export DB_NAME=$(echo "$SECRET_JSON" | jq -r .dbname)
export DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
export DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)


# Spring Boot datasource (endpoint already has :port; require SSL)
export SPRING_DATASOURCE_URL="jdbc:mysql://$${DB_ENDPOINT}/$${DB_NAME}?sslMode=REQUIRED&serverTimezone=UTC"
export SPRING_DATASOURCE_USERNAME="$${DB_USERNAME}"
export SPRING_DATASOURCE_PASSWORD="$${DB_PASSWORD}"

# run on 8080 to match your TG
nohup java -jar /home/ec2-user/app3/usermgmt-webapp.war \
  --server.port=8080 \
  > /home/ec2-user/app3/ums-start.log 2>&1 &
