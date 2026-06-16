# 13. WordPress Filesystem Permissions

## Purpose

Correct ownership and permissions limit the impact of a compromised plugin, theme or upload vector.

## Ownership Model

| Path | Owner | Group | Notes |
|---|---|---|---|
| `/var/www/wp01` | `wp01` | `wp01` | Site 1 files |
| `/var/www/wp02` | `wp02` | `wp02` | Site 2 files |
| Nginx process | `www-data` | `www-data` | Reads through backend Nginx |
| PHP-FPM wp01 | `wp01` | `wp01` | Executes wp01 PHP |
| PHP-FPM wp02 | `wp02` | `wp02` | Executes wp02 PHP |

## Recommended Permissions

```bash
find /var/www/wp01 -type d -exec chmod 755 {} \;
find /var/www/wp01 -type f -exec chmod 644 {} \;
chmod 640 /var/www/wp01/wp-config.php
chown -R wp01:wp01 /var/www/wp01
```

Repeat for `wp02`.

## Harden wp-config.php

```bash
chmod 640 /var/www/wp01/wp-config.php
chown wp01:www-data /var/www/wp01/wp-config.php
```

## Block PHP in Uploads

Create `.user.ini` or rely on Nginx deny rules. Backend Nginx must include:

```nginx
location ~* /wp-content/uploads/.*\.php$ {
    deny all;
}
```

## Permission Audit Script

```bash
#!/bin/bash
set -e
SITE_ROOT="${1:-/var/www/wp01}"
SITE_USER="$(basename "$SITE_ROOT")"
chown -R "$SITE_USER:$SITE_USER" "$SITE_ROOT"
find "$SITE_ROOT" -type d -exec chmod 755 {} \;
find "$SITE_ROOT" -type f -exec chmod 644 {} \;
chmod 640 "$SITE_ROOT/wp-config.php"
```

## Special Protection

Monitor unexpected PHP files in uploads:

```bash
find /var/www/wp01/wp-content/uploads -type f -name '*.php' -ls
```

Expected result: no files.
