#!/usr/bin/env bash
set -euo pipefail

# --- Option A: dev smoke test without any DB -------------------------------
# docker run ... -e SKIP_DB=true app3
if [[ "${SKIP_DB:-false}" == "true" ]]; then
  echo "[entrypoint] SKIP_DB=true -> starting app WITHOUT datasource autoconfig"
  exec java -jar /app/usermgmt-webapp.war \
    --server.port=8080 \
    --spring.autoconfigure.exclude=org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
fi

# --- Option B: use explicit DB_* envs (skip Secrets Manager) ---------------
# docker run ... -e DB_ENDPOINT=... -e DB_NAME=... -e DB_USERNAME=... -e DB_PASSWORD=...
if [[ -n "${DB_ENDPOINT:-}" && -n "${DB_NAME:-}" && -n "${DB_USERNAME:-}" && -n "${DB_PASSWORD:-}" ]]; then
  echo "[entrypoint] Using DB_* environment variables"
  DB_PORT="${DB_PORT:-3306}"
else
  # --- Option C: fetch from AWS Secrets Manager ----------------------------
  : "${SECRET_ID:?SECRET_ID env var is required (or set SKIP_DB=true, or pass DB_* envs)}}"
  AWS_REGION="${AWS_REGION:-${AWS_DEFAULT_REGION:-}}"
  : "${AWS_REGION:?AWS_REGION or AWS_DEFAULT_REGION is required}"

  echo "[entrypoint] Fetching secret $SECRET_ID from region $AWS_REGION..."
  SECRET_JSON=$(aws secretsmanager get-secret-value \
    --region "$AWS_REGION" \
    --secret-id "$SECRET_ID" \
    --query SecretString --output text)

  # Your secret JSON must expose these keys:
  # { "host":"...", "dbname":"...", "username":"...", "password":"...", "port":3306 }
  DB_ENDPOINT=$(echo "$SECRET_JSON" | jq -r .host)
  DB_NAME=$(echo "$SECRET_JSON" | jq -r .dbname)
  DB_USERNAME=$(echo "$SECRET_JSON" | jq -r .username)
  DB_PASSWORD=$(echo "$SECRET_JSON" | jq -r .password)
  DB_PORT=$(echo "$SECRET_JSON" | jq -r '.port // 3306')

  if [[ -z "$DB_ENDPOINT" || -z "$DB_NAME" || -z "$DB_USERNAME" || -z "$DB_PASSWORD" ]]; then
    echo "[entrypoint] ERROR: Missing one or more DB fields from secret."
    echo " host='${DB_ENDPOINT:-}' port='${DB_PORT:-}' dbname='${DB_NAME:-}' user='${DB_USERNAME:-}'"
    exit 1
  fi
fi

SPRING_DATASOURCE_URL="jdbc:mysql://${DB_ENDPOINT}:${DB_PORT}/${DB_NAME}?sslMode=REQUIRED&serverTimezone=UTC"

echo "[entrypoint] Starting app on :8080"
exec java -jar /app/usermgmt-webapp.war \
  --server.port=8080 \
  --spring.datasource.url="${SPRING_DATASOURCE_URL}" \
  --spring.datasource.username="${DB_USERNAME}" \
  --spring.datasource.password="${DB_PASSWORD}"
