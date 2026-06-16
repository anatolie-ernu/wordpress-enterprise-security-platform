#!/usr/bin/env bash
set -euo pipefail
source .env
ufw --force reset
ufw default deny incoming
ufw default allow outgoing
ufw allow 2222/tcp comment 'SSH custom port'
ufw allow 80/tcp comment 'NPM public HTTP'
ufw allow 443/tcp comment 'NPM public HTTPS'
ufw allow from "${LAN_CIDR}" to any port 81 proto tcp comment 'NPM admin LAN only'
ufw deny 81/tcp comment 'Block public NPM admin'
ufw --force enable
ufw status verbose
