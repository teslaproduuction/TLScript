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
- ✅ Выпуск сертификатов Let's Encrypt через HTTP валидацию
- ✅ Выпуск wildcard сертификатов через Cloudflare DNS
- ✅ Отзыв сертификатов
- ✅ Принудительное обновление сертификатов
- ✅ Просмотр всех установленных сертификатов

### Автоматизация
- ✅ Автоматическая установка всех зависимостей
- ✅ Настройка cron для автоматического продления
- ✅ Логирование процесса обновления
- ✅ Автообновление acme.sh

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
  0. Exit Script
————————————————
  1. Issue SSL Certificate (HTTP validation)
  2. Issue SSL Certificate (Cloudflare DNS)
  3. Revoke Certificate
  4. Force Renew Certificate
  5. List All Certificates
————————————————
  6. Install Dependencies
  7. Setup Automatic Renewal
  8. Check Auto-Renewal Status

Please enter your selection [0-8]:
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

| Команда | Описание |
|---------|----------|
| `install` | Установить все зависимости |
| `issue` | Выпустить сертификат через HTTP |
| `cloudflare` | Выпустить сертификат через Cloudflare DNS |
| `revoke` | Отозвать сертификат |
| `renew` | Принудительно обновить сертификат |
| `list` | Показать все сертификаты |
| `check` | Проверить статус автообновления |
| `setup-renewal` | Настроить автоматическое продление |

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
- ✅ Issue Let's Encrypt certificates via HTTP validation
- ✅ Issue wildcard certificates via Cloudflare DNS
- ✅ Revoke certificates
- ✅ Force renew certificates
- ✅ View all installed certificates

### Automation
- ✅ Automatic installation of all dependencies
- ✅ Setup cron for automatic renewal
- ✅ Renewal process logging
- ✅ Auto-update acme.sh

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
  0. Exit Script
————————————————
  1. Issue SSL Certificate (HTTP validation)
  2. Issue SSL Certificate (Cloudflare DNS)
  3. Revoke Certificate
  4. Force Renew Certificate
  5. List All Certificates
————————————————
  6. Install Dependencies
  7. Setup Automatic Renewal
  8. Check Auto-Renewal Status

Please enter your selection [0-8]:
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

| Command | Description |
|---------|-------------|
| `install` | Install all dependencies |
| `issue` | Issue certificate via HTTP |
| `cloudflare` | Issue certificate via Cloudflare DNS |
| `revoke` | Revoke certificate |
| `renew` | Force renew certificate |
| `list` | Show all certificates |
| `check` | Check auto-renewal status |
| `setup-renewal` | Setup automatic renewal |

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