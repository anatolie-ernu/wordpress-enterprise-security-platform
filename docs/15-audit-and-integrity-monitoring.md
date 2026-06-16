# 15. Audit and Integrity Monitoring

## Purpose

Audit and integrity checks help detect unauthorized modifications in WordPress core, plugins, themes and configuration files.

## auditd Installation

```bash
apt install -y auditd audispd-plugins
systemctl enable --now auditd
```

## auditd Rules

Create:

```bash
nano /etc/audit/rules.d/wordpress-platform.rules
```

Content:

```text
-w /var/www/wp01 -p wa -k wp01-files
-w /var/www/wp02 -p wa -k wp02-files
-w /etc/nginx -p wa -k nginx-config
-w /etc/php/8.3/fpm -p wa -k php-fpm-config
-w /etc/fail2ban -p wa -k fail2ban-config
-w /opt/docker/nginx-proxy-manager -p wa -k npm-data
```

Apply:

```bash
augenrules --load
systemctl restart auditd
```

Search events:

```bash
ausearch -k wp01-files
ausearch -k nginx-config
```

## WP-CLI Integrity Checks

Install WP-CLI:

```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
```

Verify WordPress core:

```bash
sudo -u wp01 wp --path=/var/www/wp01 core verify-checksums
```

List modified plugins:

```bash
sudo -u wp01 wp --path=/var/www/wp01 plugin list
```

## Suspicious File Checks

```bash
find /var/www/wp01/wp-content/uploads -type f -name '*.php' -ls
find /var/www/wp01 -type f -mtime -2 -ls
find /var/www/wp01 -type f -perm -002 -ls
```

## Log Review

```bash
tail -f /var/log/nginx/wp01.access.log
tail -f /var/log/nginx/wp01.error.log
tail -f /var/log/php8.3-fpm/wp01-error.log
journalctl -u nginx -u php8.3-fpm -u mariadb -u fail2ban -f
```
