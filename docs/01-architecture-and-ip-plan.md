# 01. Architecture and IP Plan

## Design Principle

The platform uses a single Debian 13 host with a clear separation between public reverse proxy traffic and local backend application services.

Nginx Proxy Manager is the only public HTTP/HTTPS entry point. Backend WordPress Nginx vhosts and MariaDB are local-only services and must not be reachable directly from the network.

## Logical Flow

```text
Client -> Cloudflare -> NPM Docker container -> Backend Nginx localhost -> PHP-FPM pool -> MariaDB localhost
```

## Component Addressing Table

| Component | Address | Port | Exposure | Notes |
|---|---:|---:|---|---|
| Debian host | `10.10.10.20` | - | LAN | Main server |
| NPM HTTP | `0.0.0.0` | `80/tcp` | Public | Cloudflare/public traffic |
| NPM HTTPS | `0.0.0.0` | `443/tcp` | Public | Cloudflare/public traffic |
| NPM Admin UI | `10.10.10.20` | `81/tcp` | LAN only | Never expose publicly |
| Backend Nginx wp01 | `127.0.0.1` | `8081/tcp` | Localhost only | Accessed only by NPM |
| Backend Nginx wp02 | `127.0.0.1` | `8082/tcp` | Localhost only | Accessed only by NPM |
| MariaDB | `127.0.0.1` | `3306/tcp` | Localhost only | Shared DB instance |
| PHP-FPM wp01 | Unix socket | - | Local | `/run/php/php8.3-wp01.sock` |
| PHP-FPM wp02 | Unix socket | - | Local | `/run/php/php8.3-wp02.sock` |

## Site Isolation Model

| Site | Linux User | Web Root | PHP-FPM Pool | Database | Backend Port |
|---|---|---|---|---|---:|
| wp01 | `wp01` | `/var/www/wp01` | `wp01` | `wp01_db` | 8081 |
| wp02 | `wp02` | `/var/www/wp02` | `wp02` | `wp02_db` | 8082 |

## Security Boundaries

- NPM accepts public traffic.
- Backend Nginx accepts traffic only from localhost.
- PHP-FPM pools run under dedicated users.
- MariaDB accepts local connections only.
- UFW blocks public access to administrative and backend ports.
- Fail2Ban works with real visitor IP from Cloudflare/NPM headers.

## DNS Model

| Record | Type | Target | Cloudflare Proxy |
|---|---|---|---|
| `wp01.ernu.sec` | A | Public server IP | Proxied |
| `wp02.ernu.sec` | A | Public server IP | Proxied |
| `npm.ernu.sec` | A | Optional LAN/VPN only | DNS only or not used |

Do not publish direct backend hostnames for ports `8081` and `8082`.
