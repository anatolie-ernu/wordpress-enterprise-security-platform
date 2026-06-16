# WordPress Enterprise Security Platform

**Author:** Anatolie Ernu  
**Brand:** IT & Security Solutions  
**Website:** https://www.ernu.eu  
**Repository:** https://github.com/anatolie-ernu/wordpress-enterprise-security-platform.git

## Purpose

This repository provides a complete, production-oriented WordPress deployment blueprint for **Debian 13**, with **Nginx Proxy Manager** as the public reverse proxy, **Nginx backend sites** on local loopback ports, **MariaDB** as the shared database engine, **PHP-FPM**, **Fail2Ban**, **UFW**, Cloudflare Real IP, and SSL certificates generated in Nginx Proxy Manager through **Cloudflare DNS Challenge**.

The repository is designed so that the deployment process can be understood directly from the repository, without reading the standalone PDF/DOCX guide.

## Public topology

```text
Internet / Cloudflare
        |
        v
Nginx Proxy Manager on Debian 13
Public: 80/tcp and 443/tcp
LAN Admin: 10.10.10.20:81/tcp
        |
        +--> wp01.ernu.sec -> 127.0.0.1:8081 -> Nginx backend -> PHP-FPM -> WordPress DB
        |
        +--> wp02.ernu.sec -> 127.0.0.1:8082 -> Nginx backend -> PHP-FPM -> WordPress DB
```

## Important port rule

Only **Nginx Proxy Manager** listens on public ports `80` and `443`. Backend Nginx sites never bind to public `80/443`; they listen only on loopback ports such as `127.0.0.1:8081` and `127.0.0.1:8082`.

## Documentation

Open the colored HTML documentation locally or from GitHub:

- [`docs/html/index.html`](docs/html/index.html) — colored documentation home page
- [`docs/01-architecture-and-ip-plan.md`](docs/01-architecture-and-ip-plan.md)
- [`docs/02-debian-13-preparation.md`](docs/02-debian-13-preparation.md)
- [`docs/03-shared-mariadb.md`](docs/03-shared-mariadb.md)
- [`docs/04-nginx-proxy-manager.md`](docs/04-nginx-proxy-manager.md)
- [`docs/05-cloudflare-real-ip-and-ssl.md`](docs/05-cloudflare-real-ip-and-ssl.md)
- [`docs/06-wordpress-installation.md`](docs/06-wordpress-installation.md)
- [`docs/07-backend-nginx-sites.md`](docs/07-backend-nginx-sites.md)
- [`docs/08-fail2ban-and-firewall.md`](docs/08-fail2ban-and-firewall.md)
- [`docs/09-backup-restore.md`](docs/09-backup-restore.md)
- [`docs/10-operations-and-troubleshooting.md`](docs/10-operations-and-troubleshooting.md)
- [`docs/11-github-import.md`](docs/11-github-import.md)

## Quick start

```bash
sudo -i
cd /opt
git clone https://github.com/anatolie-ernu/wordpress-enterprise-security-platform.git
cd wordpress-enterprise-security-platform
cp .env.example .env
nano .env
bash scripts/00-preflight.sh
bash scripts/01-install-base.sh
bash scripts/02-create-databases.sh
bash scripts/03-install-nginx-proxy-manager.sh
bash scripts/04-create-wordpress-site.sh wp01 wp01.ernu.sec 8081
bash scripts/05-apply-firewall.sh
```

After installation, open Nginx Proxy Manager from the local network:

```text
http://10.10.10.20:81
```

## License

MIT License. Author attribution must be preserved in copies or substantial portions of this project.
