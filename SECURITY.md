# Security Policy

## Supported version

| Version | Supported |
|---|---|
| v1.x | Yes |

## Security model

- Nginx Proxy Manager is the only public listener on ports 80 and 443.
- NPM management is bound to the LAN IP on port 81 and protected by UFW.
- Backend WordPress Nginx sites listen only on `127.0.0.1` ports.
- NPM and WordPress use the same MariaDB service, but separate databases and users.
- Cloudflare API tokens must never be committed to Git.

## Reporting

Report security issues privately to the repository owner.

Author attribution must be preserved in copies or substantial portions of this project.
