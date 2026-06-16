# UFW Firewall Rules - WordPress Enterprise Security Platform

This folder contains the firewall policy for the single-host deployment model used by this project.

## Traffic Model

| Service | Bind Address | Port | Exposure |
|---|---:|---:|---|
| Nginx Proxy Manager HTTP | 0.0.0.0 | 80/tcp | Public |
| Nginx Proxy Manager HTTPS | 0.0.0.0 | 443/tcp | Public |
| Nginx Proxy Manager Admin UI | 10.10.10.20 | 81/tcp | LAN only |
| SSH Management | 10.10.10.20 | 2222/tcp | Admin LAN only |
| MariaDB | 127.0.0.1 | 3306/tcp | Localhost only |
| WordPress Backend wp01 | 127.0.0.1 | 8081/tcp | Localhost only |
| WordPress Backend wp02 | 127.0.0.1 | 8082/tcp | Localhost only |

## Important Docker Note

Docker can manipulate iptables rules directly. UFW rules alone may not fully protect ports published by Docker if they are bound to `0.0.0.0`.

For this reason:

1. NPM Admin must be bound to the LAN IP only:

```yaml
ports:
  - "80:80"
  - "443:443"
  - "10.10.10.20:81:81"
```

2. Backend WordPress Nginx must listen only on localhost:

```nginx
listen 127.0.0.1:8081;
listen 127.0.0.1:8082;
```

3. MariaDB must listen only on localhost:

```ini
bind-address = 127.0.0.1
```

4. Use the included UFW script and, when Docker publishes ports, also use the DOCKER-USER chain script.

## Files

| File | Purpose |
|---|---|
| `ufw-wordpress-platform.rules.sh` | Main UFW firewall policy |
| `docker-user-chain.rules.sh` | Extra Docker-aware iptables protection |
| `firewall-plan.md` | Human-readable firewall matrix |
| `ufw-status-expected.txt` | Expected UFW status output example |
