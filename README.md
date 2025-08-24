# TLScript - SSL Certificate Management

Набор bash-скриптов для управления SSL сертификатами на Linux серверах с автоматическим продлением.

## 📋 Описание

Этот репозиторий содержит инструменты для простого и автоматизированного управления SSL сертификатами:

- **`cert_manager.sh`** - Упрощенный скрипт только для работы с SSL сертификатами
- **`tls.sh`** - Оригинальный полнофункциональный скрипт управления 3X-UI панелью

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