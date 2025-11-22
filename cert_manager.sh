#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

# Add some basic function here
function LOGD() {
    echo -e "${yellow}[DEG] $* ${plain}"
}

function LOGE() {
    echo -e "${red}[ERR] $* ${plain}"
}

function LOGI() {
    echo -e "${green}[INF] $* ${plain}"
}

# check root
[[ $EUID -ne 0 ]] && LOGE "ERROR: You must be root to run this script! \n" && exit 1

# Check OS and set release variable
if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    release=$ID
elif [[ -f /usr/lib/os-release ]]; then
    source /usr/lib/os-release
    release=$ID
else
    echo "Failed to check the system OS, please contact the author!" >&2
    exit 1
fi

echo "The OS release is: $release"

os_version=""
os_version=$(grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1)

if [[ "${release}" == "arch" ]]; then
    echo "Your OS is Arch Linux"
elif [[ "${release}" == "parch" ]]; then
    echo "Your OS is Parch linux"
elif [[ "${release}" == "manjaro" ]]; then
    echo "Your OS is Manjaro"
elif [[ "${release}" == "armbian" ]]; then
    echo "Your OS is Armbian"
elif [[ "${release}" == "opensuse-tumbleweed" ]]; then
    echo "Your OS is OpenSUSE Tumbleweed"
elif [[ "${release}" == "centos" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red} Please use CentOS 8 or higher ${plain}\n" && exit 1
    fi
elif [[ "${release}" == "ubuntu" ]]; then
    if [[ ${os_version} -lt 20 ]]; then
        echo -e "${red} Please use Ubuntu 20 or higher version!${plain}\n" && exit 1
    fi
elif [[ "${release}" == "fedora" ]]; then
    if [[ ${os_version} -lt 36 ]]; then
        echo -e "${red} Please use Fedora 36 or higher version!${plain}\n" && exit 1
    fi
elif [[ "${release}" == "debian" ]]; then
    if [[ ${os_version} -lt 11 ]]; then
        echo -e "${red} Please use Debian 11 or higher ${plain}\n" && exit 1
    fi
elif [[ "${release}" == "almalinux" ]]; then
    if [[ ${os_version} -lt 9 ]]; then
        echo -e "${red} Please use AlmaLinux 9 or higher ${plain}\n" && exit 1
    fi
elif [[ "${release}" == "rocky" ]]; then
    if [[ ${os_version} -lt 9 ]]; then
        echo -e "${red} Please use Rocky Linux 9 or higher ${plain}\n" && exit 1
    fi
elif [[ "${release}" == "oracle" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red} Please use Oracle Linux 8 or higher ${plain}\n" && exit 1
    fi
else
    echo -e "${red}Your operating system is not supported by this script.${plain}\n"
    echo "Please ensure you are using one of the following supported operating systems:"
    echo "- Ubuntu 20.04+"
    echo "- Debian 11+"
    echo "- CentOS 8+"
    echo "- Fedora 36+"
    echo "- Arch Linux"
    echo "- Parch Linux"
    echo "- Manjaro"
    echo "- Armbian"
    echo "- AlmaLinux 9+"
    echo "- Rocky Linux 9+"
    echo "- Oracle Linux 8+"
    echo "- OpenSUSE Tumbleweed"
    exit 1
fi

confirm() {
    if [[ $# -gt 1 ]]; then
        echo && read -p "$1 [Default $2]: " temp
        if [[ "${temp}" == "" ]]; then
            temp=$2
        fi
    else
        read -p "$1 [y/n]: " temp
    fi
    if [[ "${temp}" == "y" || "${temp}" == "Y" ]]; then
        return 0
    else
        return 1
    fi
}

before_show_menu() {
    echo && echo -n -e "${yellow}Press enter to return to the main menu: ${plain}" && read temp
    show_menu
}

# Install required dependencies
install_dependencies() {
    LOGI "Installing required dependencies..."
    
    case "${release}" in
    ubuntu | debian | armbian)
        apt update && apt install -y curl wget socat cron
        ;;
    centos | almalinux | rocky | oracle)
        yum update -y && yum install -y curl wget socat cronie
        systemctl enable crond
        systemctl start crond
        ;;
    fedora)
        dnf update -y && dnf install -y curl wget socat cronie
        systemctl enable crond
        systemctl start crond
        ;;
    arch | manjaro | parch)
        pacman -Sy --noconfirm curl wget socat cronie
        systemctl enable cronie
        systemctl start cronie
        ;;
    *)
        echo -e "${red}Unsupported operating system. Please install curl, wget, socat, and cron manually.${plain}\n"
        exit 1
        ;;
    esac
    
    if [ $? -ne 0 ]; then
        LOGE "Failed to install dependencies"
        exit 1
    else
        LOGI "Dependencies installed successfully"
    fi
}

install_acme() {
    cd ~ || return 1
    LOGI "Installing acme.sh..."
    curl https://get.acme.sh | sh
    if [ $? -ne 0 ]; then
        LOGE "Install acme.sh failed"
        return 1
    else
        LOGI "Install acme.sh succeed"
    fi
    return 0
}

install_certbot() {
    LOGI "Installing Certbot..."

    case "${release}" in
    ubuntu | debian | armbian)
        apt update && apt install -y certbot python3-certbot
        ;;
    centos | almalinux | rocky | oracle)
        if [[ ${os_version} -ge 8 ]]; then
            dnf install -y epel-release
            dnf install -y certbot python3-certbot
        else
            yum install -y epel-release
            yum install -y certbot python3-certbot
        fi
        ;;
    fedora)
        dnf install -y certbot python3-certbot
        ;;
    arch | manjaro | parch)
        pacman -Sy --noconfirm certbot
        ;;
    *)
        LOGE "Unsupported operating system for Certbot installation"
        return 1
        ;;
    esac

    if [ $? -ne 0 ]; then
        LOGE "Failed to install Certbot"
        return 1
    else
        LOGI "Certbot installed successfully"
    fi
    return 0
}

install_certbot_dns_plugins() {
    local plugin=$1
    LOGI "Installing Certbot DNS plugin: ${plugin}..."

    case "${release}" in
    ubuntu | debian | armbian)
        apt install -y python3-certbot-dns-${plugin}
        ;;
    centos | almalinux | rocky | oracle | fedora)
        dnf install -y python3-certbot-dns-${plugin} 2>/dev/null || yum install -y python3-certbot-dns-${plugin}
        ;;
    arch | manjaro | parch)
        # Arch uses pip for certbot plugins
        pacman -Sy --noconfirm python-pip
        pip install certbot-dns-${plugin}
        ;;
    *)
        LOGE "Unsupported operating system for Certbot DNS plugins"
        return 1
        ;;
    esac

    if [ $? -ne 0 ]; then
        LOGE "Failed to install Certbot DNS plugin: ${plugin}"
        return 1
    else
        LOGI "Certbot DNS plugin ${plugin} installed successfully"
    fi
    return 0
}

setup_auto_renewal() {
    LOGI "Setting up automatic certificate renewal..."
    
    # Check if acme.sh is installed
    if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
        LOGE "acme.sh is not installed. Please install it first."
        return 1
    fi
    
    # Create cron job for certificate renewal (check daily at 2:30 AM)
    cron_job="30 2 * * * ~/.acme.sh/acme.sh --cron --home ~/.acme.sh > /var/log/acme_renewal.log 2>&1"
    
    # Check if cron job already exists
    if crontab -l 2>/dev/null | grep -q "acme.sh --cron"; then
        LOGI "Auto renewal cron job already exists"
    else
        # Add cron job
        (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
        LOGI "Auto renewal cron job added successfully"
    fi
    
    # Enable acme.sh auto-upgrade
    ~/.acme.sh/acme.sh --upgrade --auto-upgrade
    
    LOGI "Automatic certificate renewal setup completed"
}

ssl_cert_issue() {
    # Install dependencies first
    install_dependencies
    
    # check for acme.sh first
    if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
        echo "acme.sh could not be found. Installing it now..."
        install_acme
        if [ $? -ne 0 ]; then
            LOGE "Install acme.sh failed, please check logs"
            exit 1
        fi
    fi

    # get the domain here,and we need verify it
    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}, checking it..."
    
    # here we need to judge whether there exists cert already
    local currentCert
    currentCert=$(~/.acme.sh/acme.sh --list | tail -1 | awk '{print $1}')

    if [ "${currentCert}" == "${domain}" ]; then
        local certInfo
        certInfo=$(~/.acme.sh/acme.sh --list)
        LOGE "System already has certificates for this domain, cannot issue again. Current certificates details:"
        LOGI "$certInfo"
        exit 1
    else
        LOGI "Your domain is ready for issuing certificate now..."
    fi

    # create a directory for install cert
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    else
        rm -rf "$certPath"
        mkdir -p "$certPath"
    fi

    # get needed port here
    local WebPort=80
    read -p "Please choose which port to use, default will be 80 port: " WebPort
    if [[ ${WebPort} -gt 65535 || ${WebPort} -lt 1 ]]; then
        LOGE "Your input ${WebPort} is invalid, will use default port 80"
        WebPort=80
    fi
    LOGI "Will use port: ${WebPort} to issue certificates, please make sure this port is open..."
    
    # Set default CA and issue certificate
    ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    ~/.acme.sh/acme.sh --issue -d ${domain} --listen-v6 --standalone --httpport ${WebPort}
    if [ $? -ne 0 ]; then
        LOGE "Issue certificates failed, please check logs"
        rm -rf ~/.acme.sh/${domain}
        exit 1
    else
        LOGI "Issue certificates succeed, installing certificates..."
    fi
    
    # install cert
    ~/.acme.sh/acme.sh --installcert -d ${domain} \
        --key-file /root/cert/${domain}/privkey.pem \
        --fullchain-file /root/cert/${domain}/fullchain.pem

    if [ $? -ne 0 ]; then
        LOGE "Install certificates failed, exit"
        rm -rf ~/.acme.sh/${domain}
        exit 1
    else
        LOGI "Install certificates succeed"
    fi

    # Set up automatic renewal
    setup_auto_renewal
    
    LOGI "Certificate installation completed successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Private key: ${certPath}/privkey.pem"
    LOGI "Full chain: ${certPath}/fullchain.pem"
}

ssl_cert_issue_CF() {
    echo -e ""
    LOGD "******Instructions for use******"
    LOGI "This Acme script requires the following data:"
    LOGI "1. Cloudflare Registered email"
    LOGI "2. Cloudflare Global API Key"
    LOGI "3. The domain name that has been resolved DNS to the current server by Cloudflare"
    LOGI "4. The script applies for a certificate. The default installation path is /root/cert"
    confirm "Confirmed?" "y"
    if [ $? -eq 0 ]; then
        # Install dependencies first
        install_dependencies

        # check for acme.sh first
        if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
            echo "acme.sh could not be found. Installing it now..."
            install_acme
            if [ $? -ne 0 ]; then
                LOGE "Install acme.sh failed, please check logs"
                exit 1
            fi
        fi

        CF_Domain=""
        CF_GlobalKey=""
        CF_AccountEmail=""
        certPath=/root/cert
        if [ ! -d "$certPath" ]; then
            mkdir $certPath
        else
            rm -rf $certPath
            mkdir $certPath
        fi
        LOGD "Please set a domain name:"
        read -p "Input your domain here: " CF_Domain
        LOGD "Your domain name is set to: ${CF_Domain}"
        LOGD "Please set the API key:"
        read -p "Input your key here: " CF_GlobalKey
        LOGD "Your API key is: ${CF_GlobalKey}"
        LOGD "Please set up registered email:"
        read -p "Input your email here: " CF_AccountEmail
        LOGD "Your registered email address is: ${CF_AccountEmail}"
        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        if [ $? -ne 0 ]; then
            LOGE "Default CA, Let's Encrypt fail, script exiting..."
            exit 1
        fi
        export CF_Key="${CF_GlobalKey}"
        export CF_Email=${CF_AccountEmail}
        ~/.acme.sh/acme.sh --issue --dns dns_cf -d ${CF_Domain} -d *.${CF_Domain} --log
        if [ $? -ne 0 ]; then
            LOGE "Certificate issuance failed, script exiting..."
            exit 1
        else
            LOGI "Certificate issued Successfully, Installing..."
        fi
        ~/.acme.sh/acme.sh --installcert -d ${CF_Domain} -d *.${CF_Domain} --ca-file /root/cert/ca.cer \
            --cert-file /root/cert/${CF_Domain}.cer --key-file /root/cert/${CF_Domain}.key \
            --fullchain-file /root/cert/fullchain.cer
        if [ $? -ne 0 ]; then
            LOGE "Certificate installation failed, script exiting..."
            exit 1
        else
            LOGI "Certificate installed Successfully"
        fi

        # Set up automatic renewal
        setup_auto_renewal

        LOGI "The certificate is installed and auto-renewal is turned on. Certificate files location:"
        ls -lah /root/cert/
        chmod 755 $certPath
    else
        show_menu
    fi
}

ssl_cert_issue_acme_route53() {
    echo -e ""
    LOGD "******Instructions for use******"
    LOGI "This script requires AWS Route53 credentials:"
    LOGI "1. AWS Access Key ID"
    LOGI "2. AWS Secret Access Key"
    LOGI "3. Domain name managed by Route53"
    LOGI "4. Certificate will be installed to /root/cert"
    confirm "Confirmed?" "y"
    if [ $? -eq 0 ]; then
        install_dependencies

        if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
            LOGI "Installing acme.sh..."
            install_acme
            if [ $? -ne 0 ]; then
                LOGE "Install acme.sh failed"
                return 1
            fi
        fi

        local domain=""
        read -p "Enter your domain name: " domain
        LOGD "Domain: ${domain}"

        local aws_key=""
        read -p "Enter AWS Access Key ID: " aws_key

        local aws_secret=""
        read -p "Enter AWS Secret Access Key: " aws_secret

        certPath="/root/cert/${domain}"
        mkdir -p "$certPath"

        export AWS_ACCESS_KEY_ID="${aws_key}"
        export AWS_SECRET_ACCESS_KEY="${aws_secret}"

        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        ~/.acme.sh/acme.sh --issue --dns dns_aws -d ${domain} -d *.${domain} --log

        if [ $? -ne 0 ]; then
            LOGE "Certificate issuance failed"
            return 1
        fi

        ~/.acme.sh/acme.sh --installcert -d ${domain} -d *.${domain} \
            --key-file ${certPath}/privkey.pem \
            --fullchain-file ${certPath}/fullchain.pem \
            --cert-file ${certPath}/cert.pem

        if [ $? -eq 0 ]; then
            LOGI "Certificate installed successfully at ${certPath}"
            setup_auto_renewal
        else
            LOGE "Certificate installation failed"
            return 1
        fi
    fi
}

ssl_cert_issue_acme_gcloud() {
    echo -e ""
    LOGD "******Instructions for use******"
    LOGI "This script requires Google Cloud DNS credentials:"
    LOGI "1. GCP Service Account JSON file"
    LOGI "2. Domain name managed by Google Cloud DNS"
    LOGI "3. Certificate will be installed to /root/cert"
    confirm "Confirmed?" "y"
    if [ $? -eq 0 ]; then
        install_dependencies

        if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
            LOGI "Installing acme.sh..."
            install_acme
            if [ $? -ne 0 ]; then
                LOGE "Install acme.sh failed"
                return 1
            fi
        fi

        local domain=""
        read -p "Enter your domain name: " domain
        LOGD "Domain: ${domain}"

        local gcp_key_file=""
        read -p "Enter path to GCP service account JSON file: " gcp_key_file

        if [ ! -f "$gcp_key_file" ]; then
            LOGE "GCP credentials file not found: ${gcp_key_file}"
            return 1
        fi

        certPath="/root/cert/${domain}"
        mkdir -p "$certPath"

        export GCE_SERVICE_ACCOUNT_FILE="${gcp_key_file}"

        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        ~/.acme.sh/acme.sh --issue --dns dns_gcloud -d ${domain} -d *.${domain} --log

        if [ $? -ne 0 ]; then
            LOGE "Certificate issuance failed"
            return 1
        fi

        ~/.acme.sh/acme.sh --installcert -d ${domain} -d *.${domain} \
            --key-file ${certPath}/privkey.pem \
            --fullchain-file ${certPath}/fullchain.pem \
            --cert-file ${certPath}/cert.pem

        if [ $? -eq 0 ]; then
            LOGI "Certificate installed successfully at ${certPath}"
            setup_auto_renewal
        else
            LOGE "Certificate installation failed"
            return 1
        fi
    fi
}

ssl_cert_issue_acme_digitalocean() {
    echo -e ""
    LOGD "******Instructions for use******"
    LOGI "This script requires DigitalOcean credentials:"
    LOGI "1. DigitalOcean API Token"
    LOGI "2. Domain name managed by DigitalOcean DNS"
    LOGI "3. Certificate will be installed to /root/cert"
    confirm "Confirmed?" "y"
    if [ $? -eq 0 ]; then
        install_dependencies

        if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
            LOGI "Installing acme.sh..."
            install_acme
            if [ $? -ne 0 ]; then
                LOGE "Install acme.sh failed"
                return 1
            fi
        fi

        local domain=""
        read -p "Enter your domain name: " domain
        LOGD "Domain: ${domain}"

        local do_token=""
        read -p "Enter DigitalOcean API Token: " do_token

        certPath="/root/cert/${domain}"
        mkdir -p "$certPath"

        export DO_API_KEY="${do_token}"

        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        ~/.acme.sh/acme.sh --issue --dns dns_dgon -d ${domain} -d *.${domain} --log

        if [ $? -ne 0 ]; then
            LOGE "Certificate issuance failed"
            return 1
        fi

        ~/.acme.sh/acme.sh --installcert -d ${domain} -d *.${domain} \
            --key-file ${certPath}/privkey.pem \
            --fullchain-file ${certPath}/fullchain.pem \
            --cert-file ${certPath}/cert.pem

        if [ $? -eq 0 ]; then
            LOGI "Certificate installed successfully at ${certPath}"
            setup_auto_renewal
        else
            LOGE "Certificate installation failed"
            return 1
        fi
    fi
}

ssl_cert_issue_acme_zerossl() {
    echo -e ""
    LOGD "******Instructions for use******"
    LOGI "This script will issue certificate using ZeroSSL CA:"
    LOGI "1. ZeroSSL account email"
    LOGI "2. Domain name"
    LOGI "3. Certificate will be installed to /root/cert"
    confirm "Confirmed?" "y"
    if [ $? -eq 0 ]; then
        install_dependencies

        if ! command -v ~/.acme.sh/acme.sh &>/dev/null; then
            LOGI "Installing acme.sh..."
            install_acme
            if [ $? -ne 0 ]; then
                LOGE "Install acme.sh failed"
                return 1
            fi
        fi

        local domain=""
        read -p "Enter your domain name: " domain
        LOGD "Domain: ${domain}"

        local email=""
        read -p "Enter your ZeroSSL account email: " email
        LOGD "Email: ${email}"

        certPath="/root/cert/${domain}"
        if [ ! -d "$certPath" ]; then
            mkdir -p "$certPath"
        else
            rm -rf "$certPath"
            mkdir -p "$certPath"
        fi

        local WebPort=80
        read -p "Choose port for validation (default 80): " WebPort
        if [[ ${WebPort} -gt 65535 || ${WebPort} -lt 1 ]]; then
            LOGE "Invalid port ${WebPort}, using default 80"
            WebPort=80
        fi
        LOGI "Using port: ${WebPort}"

        # Register with ZeroSSL
        ~/.acme.sh/acme.sh --register-account --server zerossl --eab-kid "" --eab-hmac-key ""

        # Set ZeroSSL as default CA
        ~/.acme.sh/acme.sh --set-default-ca --server zerossl

        # Issue certificate
        ~/.acme.sh/acme.sh --issue -d ${domain} --standalone --httpport ${WebPort}

        if [ $? -ne 0 ]; then
            LOGE "Certificate issuance failed"
            rm -rf ~/.acme.sh/${domain}
            return 1
        fi

        ~/.acme.sh/acme.sh --installcert -d ${domain} \
            --key-file ${certPath}/privkey.pem \
            --fullchain-file ${certPath}/fullchain.pem

        if [ $? -eq 0 ]; then
            LOGI "ZeroSSL certificate installed successfully!"
            LOGI "Certificate location: ${certPath}"
            setup_auto_renewal
        else
            LOGE "Certificate installation failed"
            return 1
        fi
    fi
}

ssl_cert_selfsigned() {
    LOGI "Generating self-signed certificate..."

    local domain=""
    read -p "Enter domain/common name for certificate: " domain
    LOGD "Domain: ${domain}"

    local days=365
    read -p "Enter validity period in days (default 365): " days
    if [[ -z "${days}" ]]; then
        days=365
    fi

    certPath="/root/cert/${domain}"
    mkdir -p "$certPath"

    # Generate private key
    openssl genrsa -out ${certPath}/privkey.pem 2048

    if [ $? -ne 0 ]; then
        LOGE "Failed to generate private key"
        return 1
    fi

    # Generate self-signed certificate
    openssl req -new -x509 -key ${certPath}/privkey.pem \
        -out ${certPath}/fullchain.pem -days ${days} \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=${domain}"

    if [ $? -eq 0 ]; then
        LOGI "Self-signed certificate generated successfully!"
        LOGI "Certificate location: ${certPath}"
        LOGI "Private key: ${certPath}/privkey.pem"
        LOGI "Certificate: ${certPath}/fullchain.pem"
        LOGI "Valid for: ${days} days"
        LOGI ""
        LOGE "WARNING: Self-signed certificates are NOT trusted by browsers!"
        LOGE "Use only for testing/development purposes."
    else
        LOGE "Failed to generate certificate"
        return 1
    fi
}

revoke_certificate() {
    local domain=""
    read -p "Please enter your domain name to revoke the certificate: " domain
    if [ -z "$domain" ]; then
        LOGE "Domain name cannot be empty"
        return 1
    fi
    ~/.acme.sh/acme.sh --revoke -d ${domain}
    if [ $? -eq 0 ]; then
        LOGI "Certificate revoked successfully"
        # Remove certificate files
        if [ -d "/root/cert/${domain}" ]; then
            rm -rf "/root/cert/${domain}"
            LOGI "Certificate files removed from /root/cert/${domain}"
        fi
    else
        LOGE "Failed to revoke certificate"
    fi
}

force_renew_certificate() {
    local domain=""
    read -p "Please enter your domain name to forcefully renew the SSL certificate: " domain
    if [ -z "$domain" ]; then
        LOGE "Domain name cannot be empty"
        return 1
    fi
    ~/.acme.sh/acme.sh --renew -d ${domain} --force
    if [ $? -eq 0 ]; then
        LOGI "Certificate renewed successfully"
    else
        LOGE "Failed to renew certificate"
    fi
}

list_certificates() {
    if command -v ~/.acme.sh/acme.sh &>/dev/null; then
        LOGI "Current certificates:"
        ~/.acme.sh/acme.sh --list
        echo ""
        LOGI "Certificate files in /root/cert/:"
        if [ -d "/root/cert" ]; then
            ls -la /root/cert/
        else
            LOGI "No certificate directory found"
        fi
    else
        LOGE "acme.sh is not installed"
    fi
}

check_auto_renewal() {
    LOGI "Checking automatic renewal status..."

    # Check cron job
    if crontab -l 2>/dev/null | grep -q "acme.sh --cron"; then
        LOGI "Auto renewal cron job is configured:"
        crontab -l | grep "acme.sh --cron"
    else
        LOGE "Auto renewal cron job is not configured"
    fi

    # Check acme.sh auto-upgrade status
    if [ -f ~/.acme.sh/account.conf ]; then
        if grep -q "AUTO_UPGRADE" ~/.acme.sh/account.conf; then
            LOGI "acme.sh auto-upgrade is enabled"
        else
            LOGI "acme.sh auto-upgrade status unknown"
        fi
    fi

    # Check last renewal log
    if [ -f /var/log/acme_renewal.log ]; then
        LOGI "Last renewal log entries:"
        tail -n 10 /var/log/acme_renewal.log
    else
        LOGI "No renewal log found yet"
    fi
}

# Certbot SSL certificate methods
ssl_cert_issue_certbot_standalone() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using standalone mode
    LOGI "Issuing certificate using Certbot standalone mode..."
    certbot certonly --standalone -d ${domain} --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Private key: ${certPath}/privkey.pem"
    LOGI "Full chain: ${certPath}/fullchain.pem"

    # Setup auto-renewal (Certbot has built-in renewal via systemd timer)
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

ssl_cert_issue_certbot_webroot() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    local webroot=""
    read -p "Please enter your webroot path (e.g., /var/www/html): " webroot
    LOGD "Your webroot path is: ${webroot}"

    # Validate webroot exists
    if [ ! -d "$webroot" ]; then
        LOGE "Webroot directory does not exist: ${webroot}"
        return 1
    fi

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using webroot mode
    LOGI "Issuing certificate using Certbot webroot mode..."
    certbot certonly --webroot -w ${webroot} -d ${domain} --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Private key: ${certPath}/privkey.pem"
    LOGI "Full chain: ${certPath}/fullchain.pem"

    # Setup auto-renewal
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

ssl_cert_issue_certbot_dns_cloudflare() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    # Install Cloudflare DNS plugin
    install_certbot_dns_plugins "cloudflare"

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    local cf_token=""
    read -p "Please enter your Cloudflare API Token: " cf_token

    # Create Cloudflare credentials file
    local creds_file="/root/.secrets/certbot/cloudflare.ini"
    mkdir -p /root/.secrets/certbot
    echo "dns_cloudflare_api_token = ${cf_token}" > ${creds_file}
    chmod 600 ${creds_file}

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using Cloudflare DNS
    LOGI "Issuing certificate using Certbot Cloudflare DNS..."
    certbot certonly --dns-cloudflare --dns-cloudflare-credentials ${creds_file} \
        -d ${domain} -d *.${domain} --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot Cloudflare DNS"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Wildcard certificate includes *.${domain}"

    # Setup auto-renewal
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

ssl_cert_issue_certbot_dns_route53() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    # Install Route53 DNS plugin
    install_certbot_dns_plugins "route53"

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    local aws_access_key=""
    read -p "Please enter your AWS Access Key ID: " aws_access_key

    local aws_secret_key=""
    read -p "Please enter your AWS Secret Access Key: " aws_secret_key

    # Create AWS credentials file
    local creds_file="/root/.secrets/certbot/route53.ini"
    mkdir -p /root/.secrets/certbot
    cat > ${creds_file} << EOF
[default]
aws_access_key_id = ${aws_access_key}
aws_secret_access_key = ${aws_secret_key}
EOF
    chmod 600 ${creds_file}

    # Export AWS credentials
    export AWS_CONFIG_FILE=${creds_file}

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using Route53 DNS
    LOGI "Issuing certificate using Certbot Route53 DNS..."
    certbot certonly --dns-route53 -d ${domain} -d *.${domain} \
        --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot Route53 DNS"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Wildcard certificate includes *.${domain}"

    # Setup auto-renewal
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

ssl_cert_issue_certbot_dns_google() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    # Install Google DNS plugin
    install_certbot_dns_plugins "google"

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    local gcp_credentials=""
    read -p "Please enter path to your GCP service account JSON file: " gcp_credentials

    if [ ! -f "$gcp_credentials" ]; then
        LOGE "GCP credentials file not found: ${gcp_credentials}"
        return 1
    fi

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using Google Cloud DNS
    LOGI "Issuing certificate using Certbot Google Cloud DNS..."
    certbot certonly --dns-google --dns-google-credentials ${gcp_credentials} \
        -d ${domain} -d *.${domain} --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot Google DNS"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Wildcard certificate includes *.${domain}"

    # Setup auto-renewal
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

ssl_cert_issue_certbot_dns_digitalocean() {
    install_dependencies

    # Check for certbot
    if ! command -v certbot &>/dev/null; then
        LOGI "Certbot not found. Installing..."
        install_certbot
        if [ $? -ne 0 ]; then
            LOGE "Failed to install Certbot"
            return 1
        fi
    fi

    # Install DigitalOcean DNS plugin
    install_certbot_dns_plugins "digitalocean"

    local domain=""
    read -p "Please enter your domain name: " domain
    LOGD "Your domain is: ${domain}"

    local email=""
    read -p "Please enter your email address: " email
    LOGD "Your email is: ${email}"

    local do_token=""
    read -p "Please enter your DigitalOcean API Token: " do_token

    # Create DigitalOcean credentials file
    local creds_file="/root/.secrets/certbot/digitalocean.ini"
    mkdir -p /root/.secrets/certbot
    echo "dns_digitalocean_token = ${do_token}" > ${creds_file}
    chmod 600 ${creds_file}

    # Create certificate directory
    certPath="/root/cert/${domain}"
    if [ ! -d "$certPath" ]; then
        mkdir -p "$certPath"
    fi

    # Issue certificate using DigitalOcean DNS
    LOGI "Issuing certificate using Certbot DigitalOcean DNS..."
    certbot certonly --dns-digitalocean --dns-digitalocean-credentials ${creds_file} \
        -d ${domain} -d *.${domain} --email ${email} --agree-tos --non-interactive

    if [ $? -ne 0 ]; then
        LOGE "Failed to issue certificate with Certbot DigitalOcean DNS"
        return 1
    fi

    # Copy certificates to our standard location
    cp /etc/letsencrypt/live/${domain}/privkey.pem ${certPath}/privkey.pem
    cp /etc/letsencrypt/live/${domain}/fullchain.pem ${certPath}/fullchain.pem

    LOGI "Certificate issued successfully!"
    LOGI "Certificate files are located at: ${certPath}"
    LOGI "Wildcard certificate includes *.${domain}"

    # Setup auto-renewal
    if command -v systemctl &>/dev/null; then
        systemctl enable certbot.timer 2>/dev/null || systemctl enable certbot-renew.timer 2>/dev/null
        systemctl start certbot.timer 2>/dev/null || systemctl start certbot-renew.timer 2>/dev/null
        LOGI "Certbot automatic renewal timer enabled"
    fi
}

show_usage() {
    echo "SSL Certificate Management Script Usage:"
    echo "=========================================="
    echo -e "GENERAL COMMANDS:"
    echo -e "  $0                    - Interactive menu"
    echo -e "  $0 install            - Install dependencies"
    echo -e "  $0 list               - List all certificates"
    echo -e "  $0 revoke             - Revoke SSL certificate"
    echo -e "  $0 renew              - Force renew SSL certificate"
    echo -e "  $0 check              - Check auto-renewal status"
    echo -e "  $0 setup-renewal      - Setup automatic renewal"
    echo ""
    echo -e "ACME.SH METHODS:"
    echo -e "  $0 acme-http          - Issue via acme.sh HTTP validation"
    echo -e "  $0 acme-cloudflare    - Issue via acme.sh Cloudflare DNS"
    echo -e "  $0 acme-route53       - Issue via acme.sh AWS Route53 DNS"
    echo -e "  $0 acme-gcloud        - Issue via acme.sh Google Cloud DNS"
    echo -e "  $0 acme-digitalocean  - Issue via acme.sh DigitalOcean DNS"
    echo -e "  $0 acme-zerossl       - Issue via acme.sh with ZeroSSL CA"
    echo ""
    echo -e "CERTBOT METHODS:"
    echo -e "  $0 certbot-standalone - Issue via Certbot standalone"
    echo -e "  $0 certbot-webroot    - Issue via Certbot webroot"
    echo -e "  $0 certbot-cf         - Issue via Certbot Cloudflare DNS"
    echo -e "  $0 certbot-route53    - Issue via Certbot AWS Route53 DNS"
    echo -e "  $0 certbot-gcloud     - Issue via Certbot Google Cloud DNS"
    echo -e "  $0 certbot-do         - Issue via Certbot DigitalOcean DNS"
    echo ""
    echo -e "OTHER:"
    echo -e "  $0 selfsigned         - Generate self-signed certificate"
    echo "=========================================="
}

show_menu() {
    echo -e "
  ${green}SSL Certificate Management Script${plain}
  ${green}0.${plain}  Exit Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${yellow}ACME.SH Methods (Let's Encrypt/ZeroSSL)${plain}
  ${green}1.${plain}  Issue via acme.sh (HTTP validation)
  ${green}2.${plain}  Issue via acme.sh (Cloudflare DNS)
  ${green}3.${plain}  Issue via acme.sh (AWS Route53 DNS)
  ${green}4.${plain}  Issue via acme.sh (Google Cloud DNS)
  ${green}5.${plain}  Issue via acme.sh (DigitalOcean DNS)
  ${green}6.${plain}  Issue via acme.sh (ZeroSSL CA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${yellow}CERTBOT Methods${plain}
  ${green}11.${plain} Issue via Certbot (Standalone)
  ${green}12.${plain} Issue via Certbot (Webroot)
  ${green}13.${plain} Issue via Certbot (Cloudflare DNS)
  ${green}14.${plain} Issue via Certbot (AWS Route53 DNS)
  ${green}15.${plain} Issue via Certbot (Google Cloud DNS)
  ${green}16.${plain} Issue via Certbot (DigitalOcean DNS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${yellow}Certificate Management${plain}
  ${green}21.${plain} Revoke Certificate
  ${green}22.${plain} Force Renew Certificate
  ${green}23.${plain} List All Certificates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ${yellow}Other Options${plain}
  ${green}31.${plain} Generate Self-Signed Certificate
  ${green}32.${plain} Install Dependencies
  ${green}33.${plain} Setup Automatic Renewal
  ${green}34.${plain} Check Auto-Renewal Status
"
    read -p "Please enter your selection: " num

    case "${num}" in
    0)
        exit 0
        ;;
    # ACME.SH methods
    1)
        ssl_cert_issue
        ;;
    2)
        ssl_cert_issue_CF
        ;;
    3)
        ssl_cert_issue_acme_route53
        ;;
    4)
        ssl_cert_issue_acme_gcloud
        ;;
    5)
        ssl_cert_issue_acme_digitalocean
        ;;
    6)
        ssl_cert_issue_acme_zerossl
        ;;
    # Certbot methods
    11)
        ssl_cert_issue_certbot_standalone
        ;;
    12)
        ssl_cert_issue_certbot_webroot
        ;;
    13)
        ssl_cert_issue_certbot_dns_cloudflare
        ;;
    14)
        ssl_cert_issue_certbot_dns_route53
        ;;
    15)
        ssl_cert_issue_certbot_dns_google
        ;;
    16)
        ssl_cert_issue_certbot_dns_digitalocean
        ;;
    # Certificate management
    21)
        revoke_certificate
        ;;
    22)
        force_renew_certificate
        ;;
    23)
        list_certificates
        ;;
    # Other options
    31)
        ssl_cert_selfsigned
        ;;
    32)
        install_dependencies
        ;;
    33)
        setup_auto_renewal
        ;;
    34)
        check_auto_renewal
        ;;
    *)
        LOGE "Please enter a valid option number"
        ;;
    esac
}

# Handle command line arguments
if [[ $# -gt 0 ]]; then
    case $1 in
    # General commands
    "install")
        install_dependencies
        ;;
    "list")
        list_certificates
        ;;
    "revoke")
        revoke_certificate
        ;;
    "renew")
        force_renew_certificate
        ;;
    "check")
        check_auto_renewal
        ;;
    "setup-renewal")
        setup_auto_renewal
        ;;
    # ACME.SH methods
    "acme-http")
        ssl_cert_issue
        ;;
    "acme-cloudflare")
        ssl_cert_issue_CF
        ;;
    "acme-route53")
        ssl_cert_issue_acme_route53
        ;;
    "acme-gcloud")
        ssl_cert_issue_acme_gcloud
        ;;
    "acme-digitalocean")
        ssl_cert_issue_acme_digitalocean
        ;;
    "acme-zerossl")
        ssl_cert_issue_acme_zerossl
        ;;
    # Certbot methods
    "certbot-standalone")
        ssl_cert_issue_certbot_standalone
        ;;
    "certbot-webroot")
        ssl_cert_issue_certbot_webroot
        ;;
    "certbot-cf")
        ssl_cert_issue_certbot_dns_cloudflare
        ;;
    "certbot-route53")
        ssl_cert_issue_certbot_dns_route53
        ;;
    "certbot-gcloud")
        ssl_cert_issue_certbot_dns_google
        ;;
    "certbot-do")
        ssl_cert_issue_certbot_dns_digitalocean
        ;;
    # Other
    "selfsigned")
        ssl_cert_selfsigned
        ;;
    # Legacy aliases for backwards compatibility
    "issue")
        ssl_cert_issue
        ;;
    "cloudflare")
        ssl_cert_issue_CF
        ;;
    *)
        show_usage
        ;;
    esac
else
    show_menu
fi