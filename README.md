# TLScript - SSL Certificate Management

[🇷🇺 Русский](#русский) | [🇺🇸 English](#english)

---

## Русский

Набор bash-скриптов для управления SSL сертификатами на Linux серверах с автоматическим продлением.

## 📋 Описание

Этот репозиторий содержит инструменты для простого и автоматизированного управления SSL сертификатами:


## 🚀 Быстрый старт

### Установка и использование cert_manager.sh

```bash
# Скачать скрипт
wget https://github.com/teslaproduuction/TLScript/raw/main/cert_manager.sh
chmod +x cert_manager.sh

# Запустить интерактивное меню
sudo ./cert_manager.sh

# Или использовать прямые команды
sudo ./cert_manager.sh install    # Установить зависимости
sudo ./cert_manager.sh issue      # Выпустить сертификат
```

## 📖 Возможности

### SSL Сертификаты

#### ACME.SH Методы (Let's Encrypt/ZeroSSL)
- ✅ HTTP валидация (порт 80)
- ✅ Cloudflare DNS валидация
- ✅ AWS Route53 DNS валидация
- ✅ Google Cloud DNS валидация
- ✅ DigitalOcean DNS валидация
- ✅ ZeroSSL как альтернативный CA

#### Certbot Методы
- ✅ Standalone режим (порт 80)
- ✅ Webroot режим (существующий веб-сервер)
- ✅ Cloudflare DNS плагин
- ✅ AWS Route53 DNS плагин
- ✅ Google Cloud DNS плагин
- ✅ DigitalOcean DNS плагин

#### Управление Сертификатами
- ✅ Отзыв сертификатов
- ✅ Принудительное обновление сертификатов
- ✅ Просмотр всех установленных сертификатов
- ✅ Генерация самоподписанных сертификатов

### Автоматизация
- ✅ Автоматическая установка всех зависимостей
- ✅ Настройка cron для автоматического продления
- ✅ Логирование процесса обновления
- ✅ Автообновление acme.sh и certbot

### Поддерживаемые ОС
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Fedora 36+
- Arch Linux
- AlmaLinux 9+
- Rocky Linux 9+
- Oracle Linux 8+

## 📚 Подробное использование

### Интерактивное меню

```bash
sudo ./cert_manager.sh
```

Вы увидите такое меню:

```
  SSL Certificate Management Script
  0.  Exit Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ACME.SH Methods (Let's Encrypt/ZeroSSL)
  1.  Issue via acme.sh (HTTP validation)
  2.  Issue via acme.sh (Cloudflare DNS)
  3.  Issue via acme.sh (AWS Route53 DNS)
  4.  Issue via acme.sh (Google Cloud DNS)
  5.  Issue via acme.sh (DigitalOcean DNS)
  6.  Issue via acme.sh (ZeroSSL CA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CERTBOT Methods
  11. Issue via Certbot (Standalone)
  12. Issue via Certbot (Webroot)
  13. Issue via Certbot (Cloudflare DNS)
  14. Issue via Certbot (AWS Route53 DNS)
  15. Issue via Certbot (Google Cloud DNS)
  16. Issue via Certbot (DigitalOcean DNS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Certificate Management
  21. Revoke Certificate
  22. Force Renew Certificate
  23. List All Certificates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Other Options
  31. Generate Self-Signed Certificate
  32. Install Dependencies
  33. Setup Automatic Renewal
  34. Check Auto-Renewal Status

Please enter your selection:
```

#### Пример работы - Выпуск сертификата (опция 1):

```
Please enter your selection [0-8]: 1

[INF] Installing required dependencies...
[INF] Dependencies installed successfully
Installing acme.sh...
[INF] Install acme.sh succeed
Please enter your domain name: example.com
[DEG] Your domain is: example.com, checking it...
[INF] Your domain is ready for issuing certificate now...
Please choose which port to use, default will be 80 port: 80
[INF] Will use port: 80 to issue certificates, please make sure this port is open...
[INF] Issue certificates succeed, installing certificates...
[INF] Install certificates succeed
[INF] Setting up automatic certificate renewal...
[INF] Auto renewal cron job added successfully
[INF] Automatic certificate renewal setup completed
[INF] Certificate installation completed successfully!
[INF] Certificate files are located at: /root/cert/example.com
[INF] Private key: /root/cert/example.com/privkey.pem
[INF] Full chain: /root/cert/example.com/fullchain.pem
```

#### Пример работы - Cloudflare сертификат (опция 2):

```
Please enter your selection [0-8]: 2

[DEG] ******Instructions for use******
[INF] This Acme script requires the following data:
[INF] 1. Cloudflare Registered email
[INF] 2. Cloudflare Global API Key
[INF] 3. The domain name that has been resolved DNS to the current server by Cloudflare
[INF] 4. The script applies for a certificate. The default installation path is /root/cert
Confirmed? [y/n]: y

Please set a domain name:
Input your domain here: example.com
[DEG] Your domain name is set to: example.com
Please set the API key:
Input your key here: your_cloudflare_api_key_here
[DEG] Your API key is: your_cloudflare_api_key_here
Please set up registered email:
Input your email here: your@email.com
[DEG] Your registered email address is: your@email.com
[INF] Certificate issued Successfully, Installing...
[INF] Certificate installed Successfully
[INF] Auto renewal cron job added successfully
[INF] The certificate is installed and auto-renewal is turned on. Certificate files location:
total 16K
-rw-r--r-- 1 root root 1.8K Jan 15 10:30 ca.cer
-rw-r--r-- 1 root root 3.8K Jan 15 10:30 example.com.cer
-rw-r--r-- 1 root root 1.7K Jan 15 10:30 example.com.key
-rw-r--r-- 1 root root 5.5K Jan 15 10:30 fullchain.cer
```

#### Проверка статуса (опция 8):

```
Please enter your selection [0-8]: 8

[INF] Checking automatic renewal status...
[INF] Auto renewal cron job is configured:
30 2 * * * ~/.acme.sh/acme.sh --cron --home ~/.acme.sh > /var/log/acme_renewal.log 2>&1
[INF] acme.sh auto-upgrade is enabled
[INF] Last renewal log entries:
[Sat Jan 15 02:30:01 UTC 2024] Renewing domain: example.com
[Sat Jan 15 02:30:01 UTC 2024] Domain example.com renewed successfully
[Sat Jan 15 02:30:02 UTC 2024] Cert success.
```

### Командная строка

Скрипт поддерживает прямой вызов функций через командную строку:

| Команда | Описание |
|---------|----------|
| `install` | Установить все зависимости (acme.sh, certbot) |
| `issue` | Выпустить сертификат через HTTP (acme.sh) |
| `cloudflare` | Выпустить сертификат через Cloudflare DNS (acme.sh) |
| `route53` | Выпустить сертификат через AWS Route53 DNS (acme.sh) |
| `gcloud` | Выпустить сертификат через Google Cloud DNS (acme.sh) |
| `digitalocean` | Выпустить сертификат через DigitalOcean DNS (acme.sh) |
| `zerossl` | Выпустить сертификат через ZeroSSL CA (acme.sh) |
| `certbot-standalone` | Выпустить сертификат через Certbot standalone |
| `certbot-webroot` | Выпустить сертификат через Certbot webroot |
| `self-signed` | Создать самоподписанный сертификат |
| `revoke` | Отозвать сертификат |
| `renew` | Принудительно обновить сертификат |
| `list` | Показать все сертификаты |
| `check` | Проверить статус автообновления |
| `setup-renewal` | Настроить автоматическое продление |

## 🧪 Тестирование

Проект включает комплексную систему автоматического тестирования через GitHub Actions:

### Тестовые наборы

1. **Основные тесты** (`test.yml`) - выполняются при каждом push/PR:
   - ✅ ShellCheck анализ кода
   - ✅ Проверка синтаксиса Bash
   - ✅ Тесты базовой функциональности
   - ✅ Проверка установки зависимостей
   - ✅ Анализ безопасности
   - ✅ Проверка документации
   - ✅ Интеграционные тесты
   - ✅ Тесты производительности

2. **Мультиплатформенные тесты** (`multi-os-test.yml`):
   - Ubuntu 20.04, 22.04, 24.04
   - Debian 11, 12
   - CentOS Stream 8, 9
   - AlmaLinux 9
   - Rocky Linux 9
   - Fedora 38, 39, 40
   - Arch Linux
   - openSUSE Tumbleweed

3. **Альтернативные тесты** (`alt-os-test.yml`):
   - Amazon Linux 2023
   - Oracle Linux 8, 9
   - Red Hat UBI 8, 9
   - Alpine Linux
   - BusyBox

4. **Проверка качества кода** (`code-quality.yml`):
   - ShellCheck с разными уровнями строгости
   - Сканирование безопасности
   - Проверка стиля кода
   - Анализ зависимостей

### Локальное тестирование

Перед коммитом рекомендуется запустить локальные тесты:

```bash
# Проверка синтаксиса
bash -n cert_manager.sh

# ShellCheck анализ (требует установки shellcheck)
shellcheck -S warning cert_manager.sh

# Базовый функциональный тест
echo "0" | sudo ./cert_manager.sh
```

## 🔧 Примеры использования

### Выпуск обычного сертификата

```bash
sudo ./cert_manager.sh issue
# Введите домен: example.com
# Введите порт (по умолчанию 80): 80
```

### Выпуск wildcard сертификата через Cloudflare

```bash
sudo ./cert_manager.sh cloudflare
# Введите домен: example.com
# Введите Cloudflare API Key: your_api_key
# Введите email: your@email.com
```

### Проверка автообновления

```bash
sudo ./cert_manager.sh check
# Покажет статус cron задачи и последние логи
```

## 📁 Структура файлов

```
/root/cert/              # Директория сертификатов
├── example.com/
│   ├── privkey.pem     # Приватный ключ
│   └── fullchain.pem   # Полная цепочка сертификатов
~/.acme.sh/             # Установка acme.sh
/var/log/acme_renewal.log # Лог автообновления
```

## ⚙️ Автоматическое продление

Скрипт автоматически:
1. Устанавливает cron задачу для ежедневной проверки в 2:30 ночи
2. Включает автообновление acme.sh
3. Логирует все операции продления

Cron задача выглядит так:
```bash
30 2 * * * ~/.acme.sh/acme.sh --cron --home ~/.acme.sh > /var/log/acme_renewal.log 2>&1
```

## 🛡️ Безопасность

- Требует права root для работы
- Сертификаты сохраняются в защищенной директории `/root/cert/`
- Использует официальный клиент acme.sh
- Поддерживает только доверенные центры сертификации (Let's Encrypt)

## 🔍 Требования

### Системные требования
- Linux сервер с одним из поддерживаемых дистрибутивов
- Права root
- Интернет соединение

### Для HTTP валидации
- Домен должен указывать на ваш сервер
- Порт 80 должен быть свободен

### Для Cloudflare DNS валидации
- Домен должен использовать Cloudflare как DNS
- Cloudflare Global API Key
- Email аккаунта Cloudflare

## 🐛 Устранение проблем

### Ошибка "Port 80 is busy"
```bash
# Найти процесс, использующий порт
sudo lsof -i :80
# Остановить веб-сервер временно
sudo systemctl stop nginx  # или apache2
# Выпустить сертификат
sudo ./cert_manager.sh issue
# Запустить веб-сервер обратно
sudo systemctl start nginx
```

### Проверка логов
```bash
# Логи acme.sh
tail -f ~/.acme.sh/*.log

# Логи автообновления  
tail -f /var/log/acme_renewal.log

# Проверка cron
sudo crontab -l | grep acme
```

## 📄 Лицензия

Этот проект распространяется под лицензией MIT. См. файл `LICENSE` для подробной информации.

## 🤝 Вклад в проект

Приветствуются пулл-реквесты! Для крупных изменений сначала откройте issue для обсуждения.

## 📞 Поддержка

Если у вас возникли проблемы:
1. Проверьте раздел "Устранение проблем"
2. Посмотрите логи
3. Создайте issue с описанием проблемы

---

**⚠️ Важно:** Всегда делайте резервные копии важных данных перед выполнением операций с сертификатами.

---

## English

A collection of bash scripts for SSL certificate management on Linux servers with automatic renewal.

## 📋 Description

This repository contains tools for simple and automated SSL certificate management:

- **`cert_manager.sh`** - Simplified script for SSL certificate management only
- **`tls.sh`** - Original full-featured 3X-UI panel management script

## 🚀 Quick Start

### Installing and using cert_manager.sh

```bash
# Download the script
wget https://github.com/teslaproduuction/TLScript/raw/main/cert_manager.sh
chmod +x cert_manager.sh

# Run interactive menu
sudo ./cert_manager.sh

# Or use direct commands
sudo ./cert_manager.sh install    # Install dependencies
sudo ./cert_manager.sh issue      # Issue certificate
```

## 📖 Features

### SSL Certificates

#### ACME.SH Methods (Let's Encrypt/ZeroSSL)
- ✅ HTTP validation (port 80)
- ✅ Cloudflare DNS validation
- ✅ AWS Route53 DNS validation
- ✅ Google Cloud DNS validation
- ✅ DigitalOcean DNS validation
- ✅ ZeroSSL as alternative CA

#### Certbot Methods
- ✅ Standalone mode (port 80)
- ✅ Webroot mode (existing web server)
- ✅ Cloudflare DNS plugin
- ✅ AWS Route53 DNS plugin
- ✅ Google Cloud DNS plugin
- ✅ DigitalOcean DNS plugin

#### Certificate Management
- ✅ Revoke certificates
- ✅ Force renew certificates
- ✅ View all installed certificates
- ✅ Generate self-signed certificates

### Automation
- ✅ Automatic installation of all dependencies
- ✅ Setup cron for automatic renewal
- ✅ Renewal process logging
- ✅ Auto-update acme.sh and certbot

### Supported OS
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Fedora 36+
- Arch Linux
- AlmaLinux 9+
- Rocky Linux 9+
- Oracle Linux 8+

## 📚 Detailed Usage

### Interactive Menu

```bash
sudo ./cert_manager.sh
```

You will see this menu:

```
  SSL Certificate Management Script
  0.  Exit Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  ACME.SH Methods (Let's Encrypt/ZeroSSL)
  1.  Issue via acme.sh (HTTP validation)
  2.  Issue via acme.sh (Cloudflare DNS)
  3.  Issue via acme.sh (AWS Route53 DNS)
  4.  Issue via acme.sh (Google Cloud DNS)
  5.  Issue via acme.sh (DigitalOcean DNS)
  6.  Issue via acme.sh (ZeroSSL CA)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  CERTBOT Methods
  11. Issue via Certbot (Standalone)
  12. Issue via Certbot (Webroot)
  13. Issue via Certbot (Cloudflare DNS)
  14. Issue via Certbot (AWS Route53 DNS)
  15. Issue via Certbot (Google Cloud DNS)
  16. Issue via Certbot (DigitalOcean DNS)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Certificate Management
  21. Revoke Certificate
  22. Force Renew Certificate
  23. List All Certificates
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Other Options
  31. Generate Self-Signed Certificate
  32. Install Dependencies
  33. Setup Automatic Renewal
  34. Check Auto-Renewal Status

Please enter your selection:
```

#### Example Usage - Issue Certificate (option 1):

```
Please enter your selection [0-8]: 1

[INF] Installing required dependencies...
[INF] Dependencies installed successfully
Installing acme.sh...
[INF] Install acme.sh succeed
Please enter your domain name: example.com
[DEG] Your domain is: example.com, checking it...
[INF] Your domain is ready for issuing certificate now...
Please choose which port to use, default will be 80 port: 80
[INF] Will use port: 80 to issue certificates, please make sure this port is open...
[INF] Issue certificates succeed, installing certificates...
[INF] Install certificates succeed
[INF] Setting up automatic certificate renewal...
[INF] Auto renewal cron job added successfully
[INF] Automatic certificate renewal setup completed
[INF] Certificate installation completed successfully!
[INF] Certificate files are located at: /root/cert/example.com
[INF] Private key: /root/cert/example.com/privkey.pem
[INF] Full chain: /root/cert/example.com/fullchain.pem
```

#### Example Usage - Cloudflare Certificate (option 2):

```
Please enter your selection [0-8]: 2

[DEG] ******Instructions for use******
[INF] This Acme script requires the following data:
[INF] 1. Cloudflare Registered email
[INF] 2. Cloudflare Global API Key
[INF] 3. The domain name that has been resolved DNS to the current server by Cloudflare
[INF] 4. The script applies for a certificate. The default installation path is /root/cert
Confirmed? [y/n]: y

Please set a domain name:
Input your domain here: example.com
[DEG] Your domain name is set to: example.com
Please set the API key:
Input your key here: your_cloudflare_api_key_here
[DEG] Your API key is: your_cloudflare_api_key_here
Please set up registered email:
Input your email here: your@email.com
[DEG] Your registered email address is: your@email.com
[INF] Certificate issued Successfully, Installing...
[INF] Certificate installed Successfully
[INF] Auto renewal cron job added successfully
[INF] The certificate is installed and auto-renewal is turned on. Certificate files location:
total 16K
-rw-r--r-- 1 root root 1.8K Jan 15 10:30 ca.cer
-rw-r--r-- 1 root root 3.8K Jan 15 10:30 example.com.cer
-rw-r--r-- 1 root root 1.7K Jan 15 10:30 example.com.key
-rw-r--r-- 1 root root 5.5K Jan 15 10:30 fullchain.cer
```

#### Check Status (option 8):

```
Please enter your selection [0-8]: 8

[INF] Checking automatic renewal status...
[INF] Auto renewal cron job is configured:
30 2 * * * ~/.acme.sh/acme.sh --cron --home ~/.acme.sh > /var/log/acme_renewal.log 2>&1
[INF] acme.sh auto-upgrade is enabled
[INF] Last renewal log entries:
[Sat Jan 15 02:30:01 UTC 2024] Renewing domain: example.com
[Sat Jan 15 02:30:01 UTC 2024] Domain example.com renewed successfully
[Sat Jan 15 02:30:02 UTC 2024] Cert success.
```

### Command Line

The script supports direct function calls via command line:

| Command | Description |
|---------|-------------|
| `install` | Install all dependencies (acme.sh, certbot) |
| `issue` | Issue certificate via HTTP (acme.sh) |
| `cloudflare` | Issue certificate via Cloudflare DNS (acme.sh) |
| `route53` | Issue certificate via AWS Route53 DNS (acme.sh) |
| `gcloud` | Issue certificate via Google Cloud DNS (acme.sh) |
| `digitalocean` | Issue certificate via DigitalOcean DNS (acme.sh) |
| `zerossl` | Issue certificate via ZeroSSL CA (acme.sh) |
| `certbot-standalone` | Issue certificate via Certbot standalone |
| `certbot-webroot` | Issue certificate via Certbot webroot |
| `self-signed` | Generate self-signed certificate |
| `revoke` | Revoke certificate |
| `renew` | Force renew certificate |
| `list` | Show all certificates |
| `check` | Check auto-renewal status |
| `setup-renewal` | Setup automatic renewal |

## 🧪 Testing

The project includes a comprehensive automated testing system via GitHub Actions:

### Test Suites

1. **Main Tests** (`test.yml`) - run on every push/PR:
   - ✅ ShellCheck code analysis
   - ✅ Bash syntax validation
   - ✅ Basic functionality tests
   - ✅ Dependency installation tests
   - ✅ Security analysis
   - ✅ Documentation checks
   - ✅ Integration tests
   - ✅ Performance tests

2. **Multi-Platform Tests** (`multi-os-test.yml`):
   - Ubuntu 20.04, 22.04, 24.04
   - Debian 11, 12
   - CentOS Stream 8, 9
   - AlmaLinux 9
   - Rocky Linux 9
   - Fedora 38, 39, 40
   - Arch Linux
   - openSUSE Tumbleweed

3. **Alternative OS Tests** (`alt-os-test.yml`):
   - Amazon Linux 2023
   - Oracle Linux 8, 9
   - Red Hat UBI 8, 9
   - Alpine Linux
   - BusyBox

4. **Code Quality Checks** (`code-quality.yml`):
   - ShellCheck with different severity levels
   - Security scanning
   - Code style verification
   - Dependency analysis

### Local Testing

Before committing, it's recommended to run local tests:

```bash
# Syntax check
bash -n cert_manager.sh

# ShellCheck analysis (requires shellcheck installation)
shellcheck -S warning cert_manager.sh

# Basic functional test
echo "0" | sudo ./cert_manager.sh
```

## 🔧 Usage Examples

### Issue Regular Certificate

```bash
sudo ./cert_manager.sh issue
# Enter domain: example.com
# Enter port (default 80): 80
```

### Issue Wildcard Certificate via Cloudflare

```bash
sudo ./cert_manager.sh cloudflare
# Enter domain: example.com
# Enter Cloudflare API Key: your_api_key
# Enter email: your@email.com
```

### Check Auto-renewal

```bash
sudo ./cert_manager.sh check
# Shows cron task status and latest logs
```

## 📁 File Structure

```
/root/cert/              # Certificates directory
├── example.com/
│   ├── privkey.pem     # Private key
│   └── fullchain.pem   # Full certificate chain
~/.acme.sh/             # acme.sh installation
/var/log/acme_renewal.log # Auto-renewal log
```

## ⚙️ Automatic Renewal

The script automatically:
1. Installs a cron task for daily check at 2:30 AM
2. Enables acme.sh auto-update
3. Logs all renewal operations

Cron task looks like:
```bash
30 2 * * * ~/.acme.sh/acme.sh --cron --home ~/.acme.sh > /var/log/acme_renewal.log 2>&1
```

## 🛡️ Security

- Requires root privileges to operate
- Certificates are saved in secure `/root/cert/` directory
- Uses official acme.sh client
- Supports only trusted certificate authorities (Let's Encrypt)

## 🔍 Requirements

### System Requirements
- Linux server with one of the supported distributions
- Root privileges
- Internet connection

### For HTTP Validation
- Domain must point to your server
- Port 80 must be available

### For Cloudflare DNS Validation
- Domain must use Cloudflare as DNS
- Cloudflare Global API Key
- Cloudflare account email

## 🐛 Troubleshooting

### Error "Port 80 is busy"
```bash
# Find process using the port
sudo lsof -i :80
# Stop web server temporarily
sudo systemctl stop nginx  # or apache2
# Issue certificate
sudo ./cert_manager.sh issue
# Start web server back
sudo systemctl start nginx
```

### Check Logs
```bash
# acme.sh logs
tail -f ~/.acme.sh/*.log

# Auto-renewal logs
tail -f /var/log/acme_renewal.log

# Check cron
sudo crontab -l | grep acme
```

## 📄 License

This project is distributed under the MIT License. See the `LICENSE` file for detailed information.

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss.

## 📞 Support

If you encounter problems:
1. Check the "Troubleshooting" section
2. Review the logs
3. Create an issue with problem description

---

**⚠️ Important:** Always backup important data before performing certificate operations.