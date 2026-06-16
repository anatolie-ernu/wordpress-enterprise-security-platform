#!/usr/bin/env bash
set -euo pipefail
if [ "$EUID" -ne 0 ]; then echo "Run as root"; exit 1; fi
. ./.env 2>/dev/null || true
command -v apt >/dev/null || { echo "This script expects Debian/Ubuntu apt"; exit 1; }
echo "Preflight checks completed."
