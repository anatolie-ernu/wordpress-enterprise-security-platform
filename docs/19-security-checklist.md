# 19. Security Checklist

## Host

- [ ] Debian 13 minimal installation
- [ ] SSH root login disabled
- [ ] SSH password login disabled
- [ ] SSH allowed only from admin LAN/VPN
- [ ] UFW enabled
- [ ] unattended-upgrades enabled
- [ ] auditd enabled
- [ ] unnecessary services removed

## Docker and NPM

- [ ] Docker installed from official repository
- [ ] NPM Admin bound to LAN IP only
- [ ] NPM Admin protected by UFW
- [ ] NPM uses separate database `npm`
- [ ] Cloudflare DNS Challenge token stored securely
- [ ] NPM logs stored persistently

## Backend Nginx

- [ ] Backend sites listen on `127.0.0.1` only
- [ ] wp01 on `127.0.0.1:8081`
- [ ] wp02 on `127.0.0.1:8082`
- [ ] PHP execution blocked in uploads
- [ ] sensitive files denied
- [ ] real IP log format enabled

## PHP-FPM

- [ ] Dedicated pool per website
- [ ] Dedicated Linux user per website
- [ ] `cgi.fix_pathinfo=0`
- [ ] `expose_php=Off`
- [ ] upload/post limits defined
- [ ] pool logs separated

## MariaDB

- [ ] Bound to `127.0.0.1`
- [ ] Separate database per site
- [ ] Separate user per site
- [ ] NPM has separate DB user
- [ ] remote root login disabled

## WordPress

- [ ] `DISALLOW_FILE_EDIT=true`
- [ ] unique salts configured
- [ ] HTTPS behind proxy handled
- [ ] uploads PHP execution denied
- [ ] file permissions hardened
- [ ] backups tested

## Security Controls

- [ ] Fail2Ban enabled
- [ ] Cloudflare real IP verified
- [ ] ModSecurity evaluated or deployed in detection mode
- [ ] auditd watches enabled
- [ ] WP-CLI checksum verification available
