#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

LAN_CIDR="${LAN_CIDR:-10.10.10.0/24}"
SERVER_LAN_IP="${SERVER_LAN_IP:-10.10.10.20}"
SSH_PORT="${SSH_PORT:-2222}"

export LAN_CIDR SERVER_LAN_IP SSH_PORT

bash "${PROJECT_ROOT}/configs/ufw/ufw-wordpress-platform.rules.sh"

if command -v docker >/dev/null 2>&1 && systemctl is-active --quiet docker; then
  echo "[INFO] Docker detected. Applying optional DOCKER-USER protection..."
  bash "${PROJECT_ROOT}/configs/ufw/docker-user-chain.rules.sh" || true
else
  echo "[INFO] Docker is not active yet. Skipping DOCKER-USER rules."
fi
