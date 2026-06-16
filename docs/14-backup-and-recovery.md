# 14. Backup and Recovery

## Backup Scope

Backup must include:

- WordPress files per site
- MariaDB databases
- Nginx backend configurations
- PHP-FPM pool configurations
- NPM data and certificates
- UFW/Fail2Ban configuration
- Project documentation and scripts

## Directory

```bash
mkdir -p /backup/wordpress-platform
chmod 700 /backup/wordpress-platform
```

## Manual Backup

```bash
BACKUP_DIR="/backup/wordpress-platform/$(date +%F-%H%M%S)"
mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/wp01-files.tar.gz" /var/www/wp01
tar -czf "$BACKUP_DIR/wp02-files.tar.gz" /var/www/wp02

mysqldump --single-transaction --routines --events wp01_db > "$BACKUP_DIR/wp01_db.sql"
mysqldump --single-transaction --routines --events wp02_db > "$BACKUP_DIR/wp02_db.sql"
mysqldump --single-transaction --routines --events npm > "$BACKUP_DIR/npm.sql"

tar -czf "$BACKUP_DIR/etc-nginx.tar.gz" /etc/nginx
tar -czf "$BACKUP_DIR/etc-php-fpm.tar.gz" /etc/php/8.3/fpm
tar -czf "$BACKUP_DIR/npm-data.tar.gz" /opt/docker/nginx-proxy-manager
```

## Cron Backup

```cron
0 2 * * * /usr/local/bin/wp-platform-backup.sh >> /var/log/wp-platform-backup.log 2>&1
```

## Restore Sequence

1. Reinstall Debian 13 base.
2. Restore Docker and NPM.
3. Restore MariaDB databases.
4. Restore WordPress files.
5. Restore Nginx and PHP-FPM configuration.
6. Validate ports and logs.
7. Validate application login and frontend.

## Restore Database Example

```bash
mysql wp01_db < wp01_db.sql
```

## Restore Files Example

```bash
tar -xzf wp01-files.tar.gz -C /
chown -R wp01:wp01 /var/www/wp01
```
