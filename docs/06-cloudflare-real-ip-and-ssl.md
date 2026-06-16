# 06. Cloudflare Real IP and SSL

## Purpose

Cloudflare sits in front of Nginx Proxy Manager. The platform must preserve real visitor IPs through the full chain:

```text
Cloudflare -> NPM -> Backend Nginx -> WordPress/PHP-FPM -> Logs/Fail2Ban
```

## Cloudflare DNS

Create proxied DNS records:

| Name | Type | Target | Proxy |
|---|---|---|---|
| `wp01.ernu.sec` | A | Public server IP | Proxied |
| `wp02.ernu.sec` | A | Public server IP | Proxied |

## SSL Mode

Recommended Cloudflare SSL mode:

```text
Full (strict)
```

## Cloudflare DNS Challenge Token

Create a Cloudflare API Token with minimum DNS permissions:

```text
Zone:DNS:Edit
Zone:Zone:Read
```

Limit the token to the required zone only.

Do not store the token in the repository.

## NPM Certificate Request

In Nginx Proxy Manager:

1. Go to SSL Certificates.
2. Add certificate.
3. Select Let's Encrypt.
4. Enable DNS Challenge.
5. Select Cloudflare.
6. Paste the Cloudflare API Token.
7. Request certificate.

## Backend Real IP Snippet

Create:

```bash
nano /etc/nginx/snippets/cloudflare-real-ip.conf
```

Content template:

```nginx
# Cloudflare IPv4 ranges - update regularly
set_real_ip_from 173.245.48.0/20;
set_real_ip_from 103.21.244.0/22;
set_real_ip_from 103.22.200.0/22;
set_real_ip_from 103.31.4.0/22;
set_real_ip_from 141.101.64.0/18;
set_real_ip_from 108.162.192.0/18;
set_real_ip_from 190.93.240.0/20;
set_real_ip_from 188.114.96.0/20;
set_real_ip_from 197.234.240.0/22;
set_real_ip_from 198.41.128.0/17;
set_real_ip_from 162.158.0.0/15;
set_real_ip_from 104.16.0.0/13;
set_real_ip_from 104.24.0.0/14;
set_real_ip_from 172.64.0.0/13;
set_real_ip_from 131.0.72.0/22;

real_ip_header CF-Connecting-IP;
real_ip_recursive on;
```

## Include in Backend Nginx

Inside each backend server block:

```nginx
include /etc/nginx/snippets/cloudflare-real-ip.conf;
```

## Log Format for Real IP

In `/etc/nginx/nginx.conf`:

```nginx
log_format realip '$remote_addr - $remote_user [$time_local] '
                  '"$request" $status $body_bytes_sent '
                  '"$http_referer" "$http_user_agent" '
                  'xff="$http_x_forwarded_for" cf="$http_cf_connecting_ip"';
```

Use:

```nginx
access_log /var/log/nginx/wp01.access.log realip;
```

## Verify

```bash
tail -f /var/log/nginx/wp01.access.log
```

The logged client IP must be the real visitor IP, not only the proxy container IP.

## Automatic Cloudflare IP Update

Use a scheduled script to update Cloudflare ranges from the official endpoints and reload Nginx after validation.
