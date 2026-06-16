#!/usr/bin/env bash
set -euo pipefail
source .env
mkdir -p data letsencrypt logs
chmod 750 data letsencrypt logs
if ! grep -q "host.docker.internal" docker-compose.yml; then
  echo "docker-compose.yml must include extra_hosts for host.docker.internal" >&2
  exit 1
fi
docker compose --env-file .env up -d
sleep 5
docker ps --filter name=npm-app
