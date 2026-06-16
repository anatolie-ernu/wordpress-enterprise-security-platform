# Changelog

## v1.0.7 - GitHub-ready English repository

- Added complete English documentation directly inside the repository.
- Added colored HTML documentation under `docs/html/`.
- Added detailed IP, hostname and port plan.
- Corrected architecture: NPM owns public 80/443; backend Nginx sites use loopback ports.
- Added NPM with shared MariaDB backend and external log volumes.
- Added Cloudflare DNS Challenge certificate workflow.
- Added WordPress installation process and backend Nginx site templates.
- Added UFW and Fail2Ban examples.

## v1.0.6

- Added LAN-only NPM management access through firewall rules.

## v1.0.5

- Added shared MariaDB design and NPM external log volume mapping.
