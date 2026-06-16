# 20. Validation Checklist

## Services

```bash
systemctl status nginx
systemctl status php8.3-fpm
systemctl status mariadb
systemctl status fail2ban
systemctl status docker
```

## Ports

```bash
ss -tulpn
```

Expected:

```text
0.0.0.0:80
0.0.0.0:443
10.10.10.20:81
127.0.0.1:3306
127.0.0.1:8081
127.0.0.1:8082
```

## NPM

- [ ] Admin UI reachable from LAN
- [ ] Admin UI not reachable from Internet
- [ ] Proxy host wp01 created
- [ ] Proxy host wp02 created
- [ ] SSL certificate issued via Cloudflare DNS Challenge

## WordPress

- [ ] `https://wp01.ernu.sec` loads
- [ ] `https://wp02.ernu.sec` loads
- [ ] `/wp-admin` loads
- [ ] media upload works
- [ ] plugin update works according to policy

## Real IP

```bash
tail -f /var/log/nginx/wp01.access.log
```

- [ ] logged IP is real visitor IP
- [ ] Fail2Ban bans the real visitor IP

## Backup

- [ ] database backup created
- [ ] file backup created
- [ ] restore tested on a non-production environment

## Final Security Tests

```bash
curl -I http://SERVER_PUBLIC_IP:8081
curl -I http://SERVER_PUBLIC_IP:8082
curl -I http://SERVER_PUBLIC_IP:81
```

Expected: not publicly accessible.
