# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains SSL certificate management scripts for Linux systems:

1. **`tls.sh`** - Original comprehensive 3X-UI panel management script (full functionality)
2. **`cert_manager.sh`** - Simplified SSL certificate management script (certificates only)

The `cert_manager.sh` script is a focused version that handles only SSL certificate operations with automatic renewal capabilities.

## cert_manager.sh Architecture

The simplified SSL certificate script focuses exclusively on certificate management:

### Core Functions
- **Logging functions**: `LOGD()`, `LOGE()`, `LOGI()` - Color-coded output for debugging, errors, and info
- **OS Detection**: Automatically detects Linux distribution and version, supporting Ubuntu, Debian, CentOS, Fedora, Arch, and others
- **Dependency Management**: Automatic installation of required packages (curl, wget, socat, cron)

### Main Features
1. **Certificate Issuance**: HTTP validation and Cloudflare DNS validation methods
2. **Certificate Management**: Revoke, force renew, list certificates
3. **Automatic Renewal**: Cron-based auto-renewal setup with logging
4. **Dependency Installation**: Auto-installs acme.sh, cron, and other required tools

### Menu System
- `show_menu()`: Simple menu with 9 certificate-focused options
- Direct command execution via command line arguments
- `before_show_menu()`: Standard return-to-menu pattern

### Command Line Interface
```bash
./cert_manager.sh                    # Interactive menu
./cert_manager.sh install            # Install dependencies
./cert_manager.sh issue              # Issue new SSL certificate
./cert_manager.sh cloudflare         # Issue SSL certificate via Cloudflare DNS
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
- **acme.sh**: Official ACME client for certificate management
- **System packages**: curl, wget, socat, cron/cronie
- **Let's Encrypt**: Default certificate authority
- **Cloudflare API**: For DNS validation (optional)

## Development Notes
- Self-contained single file script
- Bash best practices with proper error checking
- Automatic dependency resolution per Linux distribution
- Confirmation prompts for destructive operations
- Support for multiple Linux distributions
- No build process required - direct bash execution

## Usage Requirements
- Must run as root user
- Internet connectivity required
- Domain must point to server (for HTTP validation)
- Cloudflare API credentials (for DNS validation)
- Port 80 available (for HTTP validation)