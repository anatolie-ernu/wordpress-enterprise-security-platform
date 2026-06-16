# 00. Complete Deployment Guide

**Project:** `wordpress-enterprise-security-platform`  
**Brand:** Anatolie Ernu - IT & Security Solutions - https://www.ernu.eu  
**Target OS:** Debian 13 Trixie  
**Reference domain:** `ernu.sec`  
**Main website examples:** `wp01.ernu.sec`, `wp02.ernu.sec`

This documentation set merges the stronger parts from the previous PDF guide and the current GitHub repository structure. It keeps the current architecture with Nginx Proxy Manager, Cloudflare DNS Challenge, local backend WordPress Nginx vhosts, isolated PHP-FPM pools, shared MariaDB, UFW, Fail2Ban and optional ModSecurity/OWASP CRS hardening.

## Deployment Order

| Step | Document | Purpose |
|---:|---|---|
| 01 | `01-architecture-and-ip-plan.md` | Architecture, traffic flow, IP/port plan |
| 02 | `02-debian-13-preparation.md` | Base Debian 13 installation and OS hardening |
| 03 | `03-docker-ce-installation.md` | Docker Engine and Compose plugin for NPM |
| 04 | `04-shared-mariadb.md` | Shared local MariaDB instance for WordPress and NPM |
| 05 | `05-nginx-proxy-manager.md` | NPM deployment and admin access model |
| 06 | `06-cloudflare-real-ip-and-ssl.md` | Cloudflare SSL, DNS Challenge and real visitor IP |
| 07 | `07-wordpress-installation.md` | WordPress installation model and wp-config hardening |
| 08 | `08-backend-nginx-sites.md` | Backend Nginx vhosts listening on localhost only |
| 09 | `09-php-fpm-pools.md` | Dedicated PHP-FPM pools per website |
| 10 | `10-firewall-ufw.md` | UFW and Docker-aware firewall rules |
| 11 | `11-fail2ban.md` | Fail2Ban protection for Nginx and WordPress |
| 12 | `12-modsecurity-owasp-crs.md` | Optional ModSecurity + OWASP CRS integration |
| 13 | `13-wordpress-filesystem-permissions.md` | Ownership, permissions and upload execution blocking |
| 14 | `14-backup-and-recovery.md` | Backup and restore procedures |
| 15 | `15-audit-and-integrity-monitoring.md` | auditd, integrity checks and WP-CLI verification |
| 16 | `16-disaster-recovery.md` | Recovery scenarios |
| 17 | `17-maintenance-and-updates.md` | Maintenance, update and patching plan |
| 18 | `18-troubleshooting.md` | Troubleshooting procedures |
| 19 | `19-security-checklist.md` | Security checklist |
| 20 | `20-validation-checklist.md` | Final validation checklist |
| 21 | `21-github-import.md` | GitHub import and release tagging |

## Core Architecture

```text
Internet Client
     |
     v
Cloudflare DNS/WAF/CDN
     |
     v
Debian 13 Host - 10.10.10.20
     |
     +-- Docker: Nginx Proxy Manager
     |       |-- 0.0.0.0:80
     |       |-- 0.0.0.0:443
     |       `-- 10.10.10.20:81 LAN only
     |
     +-- Backend Nginx on host
     |       |-- 127.0.0.1:8081 -> wp01.ernu.sec
     |       `-- 127.0.0.1:8082 -> wp02.ernu.sec
     |
     +-- PHP-FPM pools
     |       |-- /run/php/php8.3-wp01.sock
     |       `-- /run/php/php8.3-wp02.sock
     |
     `-- MariaDB
             `-- 127.0.0.1:3306
```

## Important Rules

1. NPM is public only on ports `80` and `443`.
2. NPM Admin UI on port `81` is LAN only.
3. WordPress backend Nginx sites must listen on `127.0.0.1` only.
4. MariaDB must listen on `127.0.0.1` only.
5. Each WordPress site must have its own Linux user, PHP-FPM pool, database and log files.
6. Cloudflare real IP must be preserved through NPM to backend Nginx and application logs.
7. Fail2Ban must ban by real visitor IP, not by the proxy IP.

## Production Naming Convention

| Object | Example |
|---|---|
| Hostname | `web01.ernu.sec` |
| Server LAN IP | `10.10.10.20` |
| NPM Admin URL | `http://10.10.10.20:81` |
| WordPress site 1 | `wp01.ernu.sec` |
| WordPress site 2 | `wp02.ernu.sec` |
| WordPress root 1 | `/var/www/wp01` |
| WordPress root 2 | `/var/www/wp02` |
| NPM data | `/opt/docker/nginx-proxy-manager` |
| Backup root | `/backup/wordpress-platform` |
