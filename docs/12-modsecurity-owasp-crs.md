# 12. ModSecurity OWASP CRS

## Purpose

ModSecurity with OWASP Core Rule Set can add an additional WAF layer on the backend Nginx side. In this project it is optional because Cloudflare and NPM already provide edge controls, but it is useful for high-security deployments.

## Recommended Deployment Mode

Start in detection-only mode:

```text
SecRuleEngine DetectionOnly
```

Move to blocking mode only after reviewing false positives:

```text
SecRuleEngine On
```

## Install Packages

```bash
apt install -y libnginx-mod-http-modsecurity modsecurity-crs
```

## Enable ModSecurity in Nginx

```nginx
modsecurity on;
modsecurity_rules_file /etc/nginx/modsec/main.conf;
```

## OWASP CRS Exclusions

WordPress may require exclusions for specific admin actions, uploads, REST API calls or plugin endpoints.

Do not disable CRS globally. Use targeted exclusions by rule ID, URI or parameter name.

Example:

```apache
SecRuleRemoveById 949110
```

Only add exclusions after confirming the rule, request path and business impact.

## Logging

Review:

```bash
tail -f /var/log/nginx/error.log
tail -f /var/log/modsec_audit.log
```

## Production Checklist

- Start in detection mode.
- Monitor false positives for at least several days.
- Add targeted exclusions.
- Switch to blocking mode only after testing.
- Document every exclusion.
