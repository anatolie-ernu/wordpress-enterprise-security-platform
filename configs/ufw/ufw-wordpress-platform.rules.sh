#!/bin/bash

set -euo pipefail

# WordPress Enterprise Security Platform - UFW policy
# Adjust these values before running in production.

LAN_CIDR="${LAN_CIDR:-10.10.10.0/24}"
SERVER_LAN_IP="${SERVER_LAN_IP:-10.10.10.20}"
SSH_PORT="${SSH_PORT:-2222}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "[ERROR] This script must be run as root."
  exit 1
fi

echo "[INFO] Applying UFW firewall policy..."
echo "[INFO] LAN_CIDR=${LAN_CIDR}"
echo "[INFO] SERVER_LAN_IP=${SERVER_LAN_IP}"
echo "[INFO] SSH_PORT=${SSH_PORT}"

apt update
apt install -y ufw

ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Management access
ufw allow from "${LAN_CIDR}" to any port "${SSH_PORT}" proto tcp comment 'SSH admin LAN only'
ufw allow from "${LAN_CIDR}" to any port 81 proto tcp comment 'NPM admin LAN only'

# Public reverse proxy access
ufw allow 80/tcp comment 'Public HTTP to NPM'
ufw allow 443/tcp comment 'Public HTTPS to NPM'

# Defensive explicit denies
ufw deny 81/tcp comment 'Block public NPM admin'
ufw deny 3306/tcp comment 'Block public MariaDB'
ufw deny 8081/tcp comment 'Block public wp01 backend'
ufw deny 8082/tcp comment 'Block public wp02 backend'

ufw logging on
ufw --force enable

ufw status verbose

echo "[INFO] UFW policy applied."
