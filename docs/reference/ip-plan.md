> **Project:** WordPress Enterprise Security Platform  
> **Author:** Anatolie Ernu - IT & Security Solutions  
> **Website:** https://www.ernu.eu  
> **Example technical domain:** `ernu.sec`


# 01. Architecture and IP Plan

## Principle

The platform uses a single public reverse proxy. Nginx Proxy Manager owns public TCP/80 and TCP/443. Backend Nginx sites must never bind to public ports on the same host.

## Logical Flow

```text
Client Browser
     |
     v
Cloudflare DNS / Proxy / TLS Edge
     |
     v
Nginx Proxy Manager
10.10.10.20:80 / 10.10.10.20:443
     |
     +--> 127.0.0.1:8081 -> wp01 backend Nginx -> PHP-FPM wp01 -> MariaDB wp01
     +--> 127.0.0.1:8082 -> wp02 backend Nginx -> PHP-FPM wp02 -> MariaDB wp02
```

## Component Addressing Table

| Component | Hostname | IP / Bind Address | Port | Exposure | Notes |
|---|---|---:|---:|---|---|
| Debian host | `web01.ernu.sec` | `10.10.10.20` | - | LAN | Main server |
| NPM HTTP | `wp01.ernu.sec`, `wp02.ernu.sec` | `0.0.0.0` | 80 | Public | Redirect / ACME support |
| NPM HTTPS | `wp01.ernu.sec`, `wp02.ernu.sec` | `0.0.0.0` | 443 | Public | Main traffic |
| NPM Admin UI | - | `10.10.10.20` | 81 | LAN only | Protected by UFW |
| WordPress backend 1 | `wp01.ernu.sec` | `127.0.0.1` | 8081 | Local only | Nginx backend |
| WordPress backend 2 | `wp02.ernu.sec` | `127.0.0.1` | 8082 | Local only | Nginx backend |
| MariaDB | localhost | `127.0.0.1` | 3306 | Local only | Shared instance |
| SSH | `web01.ernu.sec` | `10.10.10.20` | 2222 | Admin only | Prefer VPN/LAN |

## Proxy Host Table

| Public Domain | NPM Listens On | Backend Target | Backend Port | SSL Method |
|---|---|---|---:|---|
| `wp01.ernu.sec` | 80/443 | `127.0.0.1` | 8081 | Cloudflare DNS Challenge |
| `wp02.ernu.sec` | 80/443 | `127.0.0.1` | 8082 | Cloudflare DNS Challenge |

## Why This Design Works

Linux cannot have two services listening on the same IP and port. If NPM binds `0.0.0.0:80`, host Nginx cannot also bind `0.0.0.0:80`. The correct design is to make NPM the public entry point and use private loopback ports for backend sites.

## Security Boundary

- Internet cannot reach backend Nginx directly.
- Internet cannot reach MariaDB.
- Internet cannot reach NPM Admin UI on port 81.
- Cloudflare terminates edge TLS and forwards traffic to NPM.
- NPM terminates server-side TLS and proxies internally to backend HTTP.
