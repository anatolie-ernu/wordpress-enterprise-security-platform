# 09. PHP-FPM Pools

## Purpose

Each WordPress site must run through its own PHP-FPM pool and Linux user. This reduces lateral movement risk if one site is compromised.

## Install PHP 8.3 Packages

```bash
apt install -y php8.3-fpm php8.3-cli php8.3-mysql php8.3-curl php8.3-gd \
  php8.3-mbstring php8.3-xml php8.3-zip php8.3-intl php8.3-imagick
```

## PHP Hardening

Edit:

```bash
nano /etc/php/8.3/fpm/php.ini
```

Recommended values:

```ini
expose_php = Off
memory_limit = 256M
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 120
max_input_time = 120
allow_url_fopen = Off
allow_url_include = Off
cgi.fix_pathinfo = 0
```

## wp01 Pool

```ini
[wp01]
user = wp01
group = wp01
listen = /run/php/php8.3-wp01.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660
pm = dynamic
pm.max_children = 20
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10
pm.max_requests = 500
security.limit_extensions = .php
php_admin_value[open_basedir] = /var/www/wp01:/tmp
php_admin_value[error_log] = /var/log/php8.3-fpm/wp01-error.log
php_admin_flag[log_errors] = on
```

## wp02 Pool

```ini
[wp02]
user = wp02
group = wp02
listen = /run/php/php8.3-wp02.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660
pm = dynamic
pm.max_children = 20
pm.start_servers = 5
pm.min_spare_servers = 3
pm.max_spare_servers = 10
pm.max_requests = 500
security.limit_extensions = .php
php_admin_value[open_basedir] = /var/www/wp02:/tmp
php_admin_value[error_log] = /var/log/php8.3-fpm/wp02-error.log
php_admin_flag[log_errors] = on
```

## Apply

```bash
php-fpm8.3 -t
systemctl restart php8.3-fpm
systemctl status php8.3-fpm
```

## Verify Sockets

```bash
ls -l /run/php/php8.3-wp01.sock
ls -l /run/php/php8.3-wp02.sock
```
