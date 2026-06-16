#!/usr/bin/env bash
set -euo pipefail
apt update
apt full-upgrade -y
apt install -y curl wget gnupg2 ca-certificates lsb-release apt-transport-https   software-properties-common unzip vim htop net-tools ufw fail2ban auditd git   rsync zip sudo bash-completion jq pwgen mariadb-server mariadb-client   nginx php8.3-fpm php8.3-mysql php8.3-xml php8.3-gd php8.3-mbstring   php8.3-curl php8.3-zip php8.3-intl php8.3-bcmath php8.3-soap   php8.3-imagick php8.3-redis php8.3-opcache docker.io docker-compose-plugin
systemctl enable --now mariadb nginx php8.3-fpm fail2ban auditd docker
