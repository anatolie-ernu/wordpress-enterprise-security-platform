# 07. WordPress Installation

## Site Naming

| Site | Domain | Root |
|---|---|---|
| wp01 | `wp01.ernu.sec` | `/var/www/wp01` |
| wp02 | `wp02.ernu.sec` | `/var/www/wp02` |

## Create System User

```bash
adduser --system --group --home /var/www/wp01 wp01
adduser --system --group --home /var/www/wp02 wp02
```

## Download WordPress

```bash
mkdir -p /var/www/wp01
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rsync -a wordpress/ /var/www/wp01/
chown -R wp01:wp01 /var/www/wp01
```

Repeat for `wp02` with its own root and user.

## wp-config.php Security Constants

```php
define('DISALLOW_FILE_EDIT', true);
define('DISALLOW_FILE_MODS', false);
define('FORCE_SSL_ADMIN', true);
define('WP_AUTO_UPDATE_CORE', 'minor');
define('FS_METHOD', 'direct');
```

Add reverse proxy HTTPS handling:

```php
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {
    $_SERVER['HTTPS'] = 'on';
}
```

## Database Configuration

```php
define('DB_NAME', 'wp01_db');
define('DB_USER', 'wp01_user');
define('DB_PASSWORD', 'CHANGE_THIS_COMPLEX_PASSWORD');
define('DB_HOST', 'localhost');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');
```

## Authentication Keys

Generate unique salts from the WordPress official salt generator and replace all placeholder keys.

## Disable PHP Execution in Uploads

Backend Nginx must deny PHP execution under:

```text
/wp-content/uploads/
```

See `08-backend-nginx-sites.md` and `13-wordpress-filesystem-permissions.md`.
