# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains SSL certificate management scripts for Linux systems:

1. **`tls.sh`** - Original comprehensive 3X-UI panel management script (full functionality)
2. **`cert_manager.sh`** - Comprehensive SSL certificate management script with support for multiple CAs and validation methods

The `cert_manager.sh` script is a full-featured certificate management tool supporting both acme.sh and Certbot with multiple DNS providers.

## cert_manager.sh Architecture

The comprehensive SSL certificate management script with 20+ certificate issuance methods:

### Core Functions
- **Logging functions**: `LOGD()`, `LOGE()`, `LOGI()` - Color-coded output for debugging, errors, and info
- **OS Detection**: Automatically detects Linux distribution and version, supporting Ubuntu, Debian, CentOS, Fedora, Arch, and others
- **Dependency Management**: Automatic installation of required packages (curl, wget, socat, cron/cronie)

### Certificate Issuance Methods

#### ACME.SH Methods (Let's Encrypt/ZeroSSL)
1. **ssl_cert_issue()**: HTTP validation (port 80)
2. **ssl_cert_issue_CF()**: Cloudflare DNS validation
3. **ssl_cert_issue_acme_route53()**: AWS Route53 DNS validation
4. **ssl_cert_issue_acme_gcloud()**: Google Cloud DNS validation
5. **ssl_cert_issue_acme_digitalocean()**: DigitalOcean DNS validation
6. **ssl_cert_issue_acme_zerossl()**: ZeroSSL CA integration

#### Certbot Methods
1. **ssl_cert_issue_certbot_standalone()**: Standalone mode (port 80)
2. **ssl_cert_issue_certbot_webroot()**: Webroot mode (existing web server)
3. **ssl_cert_issue_certbot_dns_cloudflare()**: Cloudflare DNS plugin
4. **ssl_cert_issue_certbot_dns_route53()**: AWS Route53 DNS plugin
5. **ssl_cert_issue_certbot_dns_google()**: Google Cloud DNS plugin
6. **ssl_cert_issue_certbot_dns_digitalocean()**: DigitalOcean DNS plugin

#### Other Methods
- **ssl_cert_selfsigned()**: Generate self-signed certificates for testing

### Certificate Management Functions
- **revoke_certificate()**: Revoke existing certificates
- **force_renew_certificate()**: Force immediate certificate renewal
- **list_certificates()**: Display all installed certificates

### Infrastructure Functions
- **install_dependencies()**: Auto-install system dependencies (curl, wget, socat, cron)
- **install_acme()**: Install and configure acme.sh
- **install_certbot()**: Install and configure Certbot
- **install_certbot_dns_plugins()**: Install DNS provider plugins for Certbot
- **setup_auto_renewal()**: Configure cron-based automatic renewal
- **check_auto_renewal()**: Verify auto-renewal status and view logs

### Menu System
- `show_menu()`: Comprehensive menu with 20+ certificate issuance options organized in 4 sections
- **ACME.SH Methods** (options 1-6): Let's Encrypt/ZeroSSL via acme.sh
- **Certbot Methods** (options 11-16): Alternative via Certbot
- **Certificate Management** (options 21-23): Revoke, renew, list
- **Other Options** (options 31-34): Self-signed, dependencies, auto-renewal
- Direct command execution via command line arguments
- `before_show_menu()`: Standard return-to-menu pattern

### Command Line Interface
```bash
./cert_manager.sh                    # Interactive menu
./cert_manager.sh install            # Install dependencies (acme.sh + certbot)
./cert_manager.sh issue              # Issue via acme.sh HTTP
./cert_manager.sh cloudflare         # Issue via acme.sh Cloudflare DNS
./cert_manager.sh route53            # Issue via acme.sh Route53 DNS
./cert_manager.sh gcloud             # Issue via acme.sh Google Cloud DNS
./cert_manager.sh digitalocean       # Issue via acme.sh DigitalOcean DNS
./cert_manager.sh zerossl            # Issue via acme.sh ZeroSSL CA
./cert_manager.sh certbot-standalone # Issue via Certbot standalone
./cert_manager.sh certbot-webroot    # Issue via Certbot webroot
./cert_manager.sh self-signed        # Generate self-signed certificate
./cert_manager.sh revoke             # Revoke SSL certificate
./cert_manager.sh renew              # Force renew SSL certificate
./cert_manager.sh list               # List all certificates
./cert_manager.sh check              # Check auto-renewal status
./cert_manager.sh setup-renewal      # Setup automatic renewal
```

### Automatic Features
- **Auto-dependency Installation**: Installs curl, wget, socat, cron/cronie automatically
- **Cron Job Setup**: Creates automatic renewal job (daily at 2:30 AM)
- **acme.sh Auto-upgrade**: Enables automatic acme.sh updates
- **Renewal Logging**: Logs renewal attempts to `/var/log/acme_renewal.log`

## Key Paths and Files (cert_manager.sh)
- **acme.sh installation**: `~/.acme.sh/`
- **Certificate storage**: `/root/cert/`
- **Renewal log**: `/var/log/acme_renewal.log`
- **Cron configuration**: System crontab
- **acme.sh config**: `~/.acme.sh/account.conf`

## Security Considerations
- Requires root privileges (checks `$EUID`)
- Downloads and executes acme.sh from official source
- Manages SSL certificates and cron jobs
- Creates certificates in secure `/root/cert/` directory
- Uses Let's Encrypt as default CA

## External Dependencies
- **acme.sh**: Official ACME client for Let's Encrypt/ZeroSSL certificates
- **Certbot**: Alternative ACME client with plugin ecosystem
- **System packages**: curl, wget, socat, cron/cronie
- **Certificate Authorities**: Let's Encrypt (default), ZeroSSL
- **DNS Providers** (optional):
  - Cloudflare API: For Cloudflare DNS validation
  - AWS Route53 API: For Route53 DNS validation
  - Google Cloud DNS API: For Google Cloud DNS validation
  - DigitalOcean API: For DigitalOcean DNS validation
- **Certbot DNS Plugins** (installed on demand):
  - python3-certbot-dns-cloudflare
  - python3-certbot-dns-route53
  - python3-certbot-dns-google
  - python3-certbot-dns-digitalocean

## Development Notes
- Self-contained single file script
- Bash best practices with proper error checking
- Automatic dependency resolution per Linux distribution
- Confirmation prompts for destructive operations
- Support for multiple Linux distributions
- No build process required - direct bash execution

## Usage Requirements

### General Requirements
- Must run as root user
- Internet connectivity required
- Valid domain name

### For HTTP Validation (acme.sh/Certbot standalone)
- Domain must point to server
- Port 80 available

### For Webroot Validation (Certbot webroot)
- Existing web server configured
- Webroot directory accessible

### For DNS Validation (any provider)
- API credentials for chosen DNS provider:
  - **Cloudflare**: Global API Key + Email or API Token
  - **AWS Route53**: AWS Access Key ID + Secret Access Key
  - **Google Cloud**: Service Account JSON key file
  - **DigitalOcean**: API Token

### For Self-Signed Certificates
- No external requirements (local generation only)