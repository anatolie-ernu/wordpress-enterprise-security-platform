# 16. Disaster Recovery

## Scenario 1: NPM Container Failure

```bash
cd /opt/docker/nginx-proxy-manager
docker compose ps
docker compose logs --tail=200
docker compose restart
```

If the container cannot start, restore NPM data from backup.

## Scenario 2: Database Corruption

1. Stop application traffic if possible.
2. Backup current corrupted state for forensic purposes.
3. Restore last known good SQL dump.
4. Validate WordPress login and frontend.

```bash
mysql wp01_db < /backup/wordpress-platform/latest/wp01_db.sql
```

## Scenario 3: WordPress File Corruption

```bash
sudo -u wp01 wp --path=/var/www/wp01 core verify-checksums
find /var/www/wp01/wp-content/uploads -type f -name '*.php' -ls
```

Restore from file backup if needed.

## Scenario 4: Certificate Failure

1. Check Cloudflare DNS token.
2. Check NPM certificate renewal logs.
3. Reissue certificate with DNS Challenge.
4. Confirm Cloudflare SSL mode is Full strict.

## Scenario 5: Backend 502 Error

Check:

```bash
systemctl status php8.3-fpm
ls -l /run/php/php8.3-wp01.sock
nginx -t
journalctl -u php8.3-fpm -n 100
```

Most common causes:

- PHP-FPM pool not running
- wrong socket path
- wrong socket ownership
- backend Nginx points to wrong pool
