#!/usr/bin/env bash
set -euo pipefail

: "${SECRET_ID:?SECRET_ID env var is required}"
: "${AWS_REGION:?AWS_REGION env var is required}"

echo "Fetching secret $SECRET_ID from region $AWS_REGION..."

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region "$AWS_REGION" \
  --secret-id "$SECRET_ID" \
  --query SecretString --output text)

DB_ENDPOINT=$(echo "$SECRET_JSON" | jq -r .host)
DB_PORT=$(echo "$SECRET_JSON" | jq -r '.port // 3306')
DB_NAME=$(echo "$SECRET_JSON" | jq -r .dbname)
DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)

SPRING_DATASOURCE_URL="jdbc:mysql://${DB_ENDPOINT}:${DB_PORT}/${DB_NAME}?sslMode=REQUIRED&serverTimezone=UTC"

exec java -jar /app/usermgmt-webapp.war \
  --server.port=8080 \
  --spring.datasource.url="${SPRING_DATASOURCE_URL}" \
  --spring.datasource.username="${DB_USERNAME}" \
  --spring.datasource.password="${DB_PASSWORD}"
