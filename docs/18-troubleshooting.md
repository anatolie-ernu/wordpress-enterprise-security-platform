# 18. Troubleshooting

## NPM Does Not Start

```bash
cd /opt/docker/nginx-proxy-manager
docker compose ps
docker compose logs --tail=200
```

Check DB connection to MariaDB.

## Port 80 or 443 Already in Use

```bash
ss -tulpn | egrep ':80|:443'
```

Only NPM should listen publicly on 80/443.

## NPM Admin UI Not Accessible

Check binding:

```bash
docker ps
ss -tulpn | grep ':81'
ufw status verbose
```

Expected:

```text
10.10.10.20:81
```

## WordPress 502 Bad Gateway

```bash
systemctl status nginx
systemctl status php8.3-fpm
ls -l /run/php/php8.3-wp01.sock
cat /var/log/nginx/wp01.error.log
```

## Wrong Visitor IP in Logs

Check headers:

- Cloudflare sends `CF-Connecting-IP`.
- NPM passes `X-Forwarded-For`.
- Backend Nginx includes Cloudflare real IP snippet.

## MariaDB Not Reachable

```bash
ss -tulpn | grep 3306
mysql -u wp01_user -p -h localhost wp01_db
```

Expected bind address:

```text
127.0.0.1:3306
```

## Fail2Ban Not Banning

```bash
fail2ban-client status
fail2ban-regex /var/log/nginx/wp01.access.log /etc/fail2ban/filter.d/wordpress-login.conf
```

If the IP is wrong, fix real IP first.

## ModSecurity False Positives

Review:

```bash
tail -f /var/log/modsec_audit.log
```

Add targeted exclusions only after analysis.
