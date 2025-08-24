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
    if [[ $# > 1 ]]; then
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
    cd ~
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
    local currentCert=$(~/.acme.sh/acme.sh --list | tail -1 | awk '{print $1}')

    if [ "${currentCert}" == "${domain}" ]; then
        local certInfo=$(~/.acme.sh/acme.sh --list)
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

show_usage() {
    echo "SSL Certificate Management Script Usage:"
    echo "------------------------------------------"
    echo -e "COMMANDS:"
    echo -e "$0                    - Interactive menu"
    echo -e "$0 install            - Install dependencies"
    echo -e "$0 issue              - Issue new SSL certificate"
    echo -e "$0 cloudflare         - Issue SSL certificate via Cloudflare DNS"
    echo -e "$0 revoke             - Revoke SSL certificate"
    echo -e "$0 renew              - Force renew SSL certificate"
    echo -e "$0 list               - List all certificates"
    echo -e "$0 check              - Check auto-renewal status"
    echo -e "$0 setup-renewal      - Setup automatic renewal"
    echo "------------------------------------------"
}

show_menu() {
    echo -e "
  ${green}SSL Certificate Management Script${plain}
  ${green}0.${plain} Exit Script
————————————————
  ${green}1.${plain} Issue SSL Certificate (HTTP validation)
  ${green}2.${plain} Issue SSL Certificate (Cloudflare DNS)
  ${green}3.${plain} Revoke Certificate
  ${green}4.${plain} Force Renew Certificate
  ${green}5.${plain} List All Certificates
————————————————
  ${green}6.${plain} Install Dependencies
  ${green}7.${plain} Setup Automatic Renewal
  ${green}8.${plain} Check Auto-Renewal Status
"
    read -p "Please enter your selection [0-8]: " num

    case "${num}" in
    0)
        exit 0
        ;;
    1)
        ssl_cert_issue
        ;;
    2)
        ssl_cert_issue_CF
        ;;
    3)
        revoke_certificate
        ;;
    4)
        force_renew_certificate
        ;;
    5)
        list_certificates
        ;;
    6)
        install_dependencies
        ;;
    7)
        setup_auto_renewal
        ;;
    8)
        check_auto_renewal
        ;;
    *)
        LOGE "Please enter the correct number [0-8]"
        ;;
    esac
}

# Handle command line arguments
if [[ $# > 0 ]]; then
    case $1 in
    "install")
        install_dependencies
        ;;
    "issue")
        ssl_cert_issue
        ;;
    "cloudflare")
        ssl_cert_issue_CF
        ;;
    "revoke")
        revoke_certificate
        ;;
    "renew")
        force_renew_certificate
        ;;
    "list")
        list_certificates
        ;;
    "check")
        check_auto_renewal
        ;;
    "setup-renewal")
        setup_auto_renewal
        ;;
    *) 
        show_usage 
        ;;
    esac
else
    show_menu
fi