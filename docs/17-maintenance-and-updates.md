# 17. Maintenance and Updates

## Weekly Tasks

```bash
apt update
apt list --upgradable
systemctl --failed
ufw status verbose
fail2ban-client status
```

Review:

- NPM logs
- backend Nginx logs
- PHP-FPM logs
- WordPress security plugin alerts
- backup success/failure

## Monthly Tasks

```bash
apt upgrade -y
docker compose pull
docker compose up -d
```

Before updating:

1. Take database backup.
2. Take file backup.
3. Export NPM data.
4. Confirm restore procedure.

## WordPress Updates

Recommended order:

1. Backup database and files.
2. Update plugins.
3. Update themes.
4. Update WordPress core.
5. Run frontend and admin validation.

## Certificate Monitoring

Check certificates in NPM monthly.

Also validate externally:

```bash
openssl s_client -connect wp01.ernu.sec:443 -servername wp01.ernu.sec </dev/null
```

## Log Rotation

Ensure logs do not fill the disk:

```bash
logrotate -d /etc/logrotate.conf
```
