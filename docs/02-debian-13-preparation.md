# 02. Debian 13 Preparation

## Minimal Installation

Use Debian 13 Trixie minimal installation. Install only:

- SSH server
- Standard system utilities

Do not install a desktop environment, print server or unnecessary network services.

## Recommended Partitioning

| Mount Point | Purpose |
|---|---|
| `/` | Operating system |
| `/var` | Logs, web content, DB files if local storage is used |
| `/home` | Admin users |
| `/backup` | Optional local backup mount |

## Initial Update

```bash
apt update && apt upgrade -y
```

## Base Packages

```bash
apt install -y   curl wget gnupg2 ca-certificates lsb-release apt-transport-https   software-properties-common unzip vim htop net-tools ufw fail2ban   auditd git rsync tar gzip jq openssl cron logrotate
```

## Hostname and Timezone

```bash
hostnamectl set-hostname web01.ernu.sec
timedatectl set-timezone Europe/Chisinau
```

Verify:

```bash
hostnamectl
timedatectl
```

## Admin User

```bash
adduser adminops
usermod -aG sudo adminops
```

## SSH Hardening

Edit:

```bash
nano /etc/ssh/sshd_config
```

Recommended values:

```text
Port 2222
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
AllowUsers adminops
MaxAuthTries 3
LoginGraceTime 30
X11Forwarding no
AllowTcpForwarding no
ClientAliveInterval 300
ClientAliveCountMax 2
```

Validate and restart:

```bash
sshd -t
systemctl restart ssh
```

Do not close the active SSH session until a new session is tested successfully.

## Kernel Hardening with sysctl

Create:

```bash
nano /etc/sysctl.d/99-wordpress-platform-hardening.conf
```

Content:

```text
net.ipv4.ip_forward = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.tcp_syncookies = 1
kernel.randomize_va_space = 2
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
fs.protected_hardlinks = 1
fs.protected_symlinks = 1
```

Apply:

```bash
sysctl --system
```

## Automatic Security Updates

```bash
apt install -y unattended-upgrades apt-listchanges
```

Enable:

```bash
dpkg-reconfigure -plow unattended-upgrades
```

Recommended file:

```bash
nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Ensure security origins are enabled for Debian Trixie.

## Service Check

```bash
systemctl --failed
ss -tulpn
```

No unexpected public service should be listening before continuing.
