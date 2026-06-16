#!/usr/bin/env bash
set -euo pipefail
ss -tulpn | grep -E ':80|:443|:81|:8081|:8082|:3306' || true
docker ps --filter name=npm-app
curl -I http://127.0.0.1:8081 || true
systemctl --no-pager status mariadb nginx php8.3-fpm fail2ban docker | sed -n '1,120p'
