#!/bin/bash

set -euo pipefail

# Extra Docker-aware firewall protection using the DOCKER-USER chain.
# Use this when Docker publishes ports on the host.

LAN_CIDR="${LAN_CIDR:-10.10.10.0/24}"
NPM_ADMIN_PORT="${NPM_ADMIN_PORT:-81}"
BACKEND_PORTS="${BACKEND_PORTS:-3306,8081,8082}"

if [[ "${EUID}" -ne 0 ]]; then
  echo "[ERROR] This script must be run as root."
  exit 1
fi

if ! iptables -S DOCKER-USER >/dev/null 2>&1; then
  echo "[ERROR] DOCKER-USER chain not found. Is Docker installed and running?"
  exit 1
fi

echo "[INFO] Applying Docker DOCKER-USER firewall policy..."

# Allow LAN to NPM Admin port.
iptables -C DOCKER-USER -p tcp -s "${LAN_CIDR}" --dport "${NPM_ADMIN_PORT}" -j RETURN 2>/dev/null || \
iptables -I DOCKER-USER 1 -p tcp -s "${LAN_CIDR}" --dport "${NPM_ADMIN_PORT}" -j RETURN

# Drop non-LAN access to NPM Admin port.
iptables -C DOCKER-USER -p tcp --dport "${NPM_ADMIN_PORT}" -j DROP 2>/dev/null || \
iptables -I DOCKER-USER 2 -p tcp --dport "${NPM_ADMIN_PORT}" -j DROP

# Drop direct external access to backend/database ports.
iptables -C DOCKER-USER -p tcp -m multiport --dports "${BACKEND_PORTS}" -j DROP 2>/dev/null || \
iptables -I DOCKER-USER 3 -p tcp -m multiport --dports "${BACKEND_PORTS}" -j DROP

iptables -S DOCKER-USER

echo "[INFO] DOCKER-USER policy applied."
echo "[INFO] To persist these rules across reboot, install iptables-persistent or create a systemd unit."
