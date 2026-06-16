#!/usr/bin/env bash
set -euo pipefail
SITE=${1:-wp01}
DOMAIN=${2:-wp01.ernu.sec}
PORT=${3:-8081}
DB_NAME="${SITE}_db"
DB_USER="${SITE}_user"
ROOT="/var/www/${SITE}"

useradd -r -s /usr/sbin/nologin -d "$ROOT" "$SITE" 2>/dev/null || true
mkdir -p "$ROOT"
cd /tmp
rm -rf wordpress latest.tar.gz
wget -q https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rsync -a wordpress/ "$ROOT/"
chown -R "$SITE:$SITE" "$ROOT"
find "$ROOT" -type d -exec chmod 755 {} \;
find "$ROOT" -type f -exec chmod 644 {} \;
cp "$ROOT/wp-config-sample.php" "$ROOT/wp-config.php"
chown "$SITE:$SITE" "$ROOT/wp-config.php"

cat > "/etc/php/8.3/fpm/pool.d/${SITE}.conf" <<EOF
[${SITE}]
user = ${SITE}
group = ${SITE}
listen = /run/php/php8.3-${SITE}.sock
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
php_admin_value[open_basedir] = ${ROOT}:/tmp
php_admin_value[error_log] = /var/log/php8.3-fpm/${SITE}-error.log
php_admin_flag[log_errors] = on
EOF

cat > "/etc/nginx/sites-available/${SITE}.conf" <<EOF
server {
    listen 127.0.0.1:${PORT};
    server_name ${DOMAIN};
    root ${ROOT};
    index index.php index.html;
    access_log /var/log/nginx/${SITE}-access.log;
    error_log /var/log/nginx/${SITE}-error.log warn;
    location / { try_files \$uri \$uri/ /index.php?\$args; }
    location = /xmlrpc.php { deny all; return 403; }
    location ~* /wp-content/uploads/.*\.php\$ { deny all; return 403; }
    location ~ /\. { deny all; }
    location ~ /wp-config\.php { deny all; }
    location ~ \.php\$ {
        try_files \$uri =404;
        include fastcgi_params;
        fastcgi_pass unix:/run/php/php8.3-${SITE}.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}
EOF
ln -sf "/etc/nginx/sites-available/${SITE}.conf" "/etc/nginx/sites-enabled/${SITE}.conf"
systemctl restart php8.3-fpm
nginx -t
systemctl reload nginx

echo "Backend site created: http://127.0.0.1:${PORT} for ${DOMAIN}"
echo "Now create an NPM Proxy Host: ${DOMAIN} -> http://127.0.0.1:${PORT}"
