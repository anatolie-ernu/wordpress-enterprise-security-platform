# 21. GitHub Import

## Repository

```text
https://github.com/anatolie-ernu/wordpress-enterprise-security-platform.git
```

## Clean Initial Import

```bash
cd wordpress-enterprise-security-platform

git init
git branch -M main
git remote add origin https://github.com/anatolie-ernu/wordpress-enterprise-security-platform.git

git add .
git commit -m "Initial release v1.0"
git push -u origin main
```

## Force Replace Existing Remote

Use only when the remote repository must be replaced completely:

```bash
git push --force -u origin main
```

## Release Tag

```bash
git tag -a v1.0 -m "WordPress Enterprise Security Platform v1.0"
git push origin v1.0
```

If the tag already exists and must be replaced:

```bash
git tag -f v1.0 -m "WordPress Enterprise Security Platform v1.0"
git push --force origin v1.0
```

## Recommended Release Notes

```text
WordPress Enterprise Security Platform v1.0

Debian 13 single-host WordPress enterprise security platform with Nginx Proxy Manager, Cloudflare DNS Challenge, local backend Nginx, dedicated PHP-FPM pools, shared MariaDB, UFW, Fail2Ban, optional ModSecurity OWASP CRS, backups and operational validation.
```
