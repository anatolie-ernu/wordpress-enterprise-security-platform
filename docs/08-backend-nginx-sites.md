# 08. Backend Nginx Sites

## Purpose

Backend Nginx serves WordPress locally only. It must not expose WordPress directly to the public network.

## Install Nginx

```bash
apt install -y nginx
systemctl enable --now nginx
```

## Global Hardening

In `/etc/nginx/nginx.conf`:

```nginx
server_tokens off;
client_max_body_size 64m;
```

## wp01 Backend Virtual Host

Create:

```bash
nano /etc/nginx/sites-available/wp01.conf
```

Content:

```nginx
server {
    listen 127.0.0.1:8081;
    server_name wp01.ernu.sec;
    root /var/www/wp01;
    index index.php index.html;

    include /etc/nginx/snippets/cloudflare-real-ip.conf;

    access_log /var/log/nginx/wp01.access.log realip;
    error_log /var/log/nginx/wp01.error.log warn;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-wp01.sock;
    }

    location ~* /wp-content/uploads/.*\.php$ {
        deny all;
    }

    location ~* /(wp-config.php|xmlrpc.php|readme.html|license.txt) {
        deny all;
    }

    location ~ /\. {
        deny all;
    }
}
```

## wp02 Backend Virtual Host

```nginx
server {
    listen 127.0.0.1:8082;
    server_name wp02.ernu.sec;
    root /var/www/wp02;
    index index.php index.html;

    include /etc/nginx/snippets/cloudflare-real-ip.conf;

    access_log /var/log/nginx/wp02.access.log realip;
    error_log /var/log/nginx/wp02.error.log warn;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-wp02.sock;
    }

    location ~* /wp-content/uploads/.*\.php$ {
        deny all;
    }

    location ~* /(wp-config.php|xmlrpc.php|readme.html|license.txt) {
        deny all;
    }

    location ~ /\. {
        deny all;
    }
}
```

## Enable Sites

```bash
ln -s /etc/nginx/sites-available/wp01.conf /etc/nginx/sites-enabled/wp01.conf
ln -s /etc/nginx/sites-available/wp02.conf /etc/nginx/sites-enabled/wp02.conf
nginx -t
systemctl reload nginx
```

## Verify Listening Addresses

```bash
ss -tulpn | grep nginx
```

Expected:

```text
127.0.0.1:8081
127.0.0.1:8082
```
