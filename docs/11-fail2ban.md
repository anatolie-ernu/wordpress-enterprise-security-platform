# 11. Fail2Ban

## Purpose

Fail2Ban protects WordPress login, XML-RPC, backend Nginx and NPM-facing logs. It must use real visitor IPs, not only the NPM container IP.

## Install

```bash
apt install -y fail2ban
systemctl enable --now fail2ban
```

## WordPress Login Filter

Create:

```bash
nano /etc/fail2ban/filter.d/wordpress-login.conf
```

Content:

```ini
[Definition]
failregex = ^<HOST> .* "POST /wp-login.php HTTP/.*" (200|302|403|429)
ignoreregex =
```

## XML-RPC Filter

```ini
[Definition]
failregex = ^<HOST> .* "POST /xmlrpc.php HTTP/.*" (200|403|429)
ignoreregex =
```

## Jail Configuration

Create:

```bash
nano /etc/fail2ban/jail.d/wordpress-platform.local
```

Content:

```ini
[wordpress-login]
enabled = true
filter = wordpress-login
logpath = /var/log/nginx/wp01.access.log
          /var/log/nginx/wp02.access.log
maxretry = 5
findtime = 10m
bantime = 1h
action = ufw

[wordpress-xmlrpc]
enabled = true
filter = wordpress-xmlrpc
logpath = /var/log/nginx/wp01.access.log
          /var/log/nginx/wp02.access.log
maxretry = 3
findtime = 10m
bantime = 6h
action = ufw
```

## Apply

```bash
fail2ban-client reload
fail2ban-client status
fail2ban-client status wordpress-login
```

## Verification

```bash
fail2ban-regex /var/log/nginx/wp01.access.log /etc/fail2ban/filter.d/wordpress-login.conf
```

If the matched IP is the proxy IP, fix Cloudflare/NPM/backend real IP handling first.
