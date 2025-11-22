# Changelog

[🇷🇺 Русский](#русский) | [🇺🇸 English](#english)

---

## Русский

Все значимые изменения в проекте TLScript будут документированы в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Множественная поддержка DNS провайдеров** - Добавлена поддержка AWS Route53, Google Cloud DNS и DigitalOcean DNS валидации
- **Интеграция Certbot** - Полная поддержка Certbot как альтернативы acme.sh со standalone и webroot методами
- **Поддержка ZeroSSL** - Добавлен ZeroSSL как альтернативный центр сертификации через acme.sh
- **Самоподписанные сертификаты** - Новая опция для генерации самоподписанных сертификатов для тестирования
- **Улучшенная система меню** - Реорганизованное меню с 20+ методами выпуска сертификатов, сгруппированными по типу

### Методы Certbot (Новые)
- Certbot Standalone режим (валидация через порт 80)
- Certbot Webroot режим (существующий веб-сервер)
- Certbot с плагином Cloudflare DNS
- Certbot с плагином AWS Route53 DNS
- Certbot с плагином Google Cloud DNS
- Certbot с плагином DigitalOcean DNS

### Расширения ACME.SH (Новые)
- AWS Route53 DNS валидация
- Google Cloud DNS валидация
- DigitalOcean DNS валидация
- Интеграция ZeroSSL CA

## [1.0.0] - 2025-01-24

### Added
- Первый релиз TLScript
- `cert_manager.sh` - основной скрипт для управления SSL сертификатами
- Поддержка HTTP валидации через acme.sh
- Поддержка DNS валидации через Cloudflare
- Автоматическая установка зависимостей (curl, wget, socat, cron)
- Настройка автоматического продления сертификатов через cron
- Интерактивное меню для удобства использования
- Поддержка командной строки для автоматизации
- Функции отзыва и принудительного обновления сертификатов
- Просмотр всех установленных сертификатов
- Логирование процесса продления сертификатов
- Проверка статуса автоматического продления

### Supported OS
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Fedora 36+
- Arch Linux
- Parch Linux
- Manjaro
- Armbian
- AlmaLinux 9+
- Rocky Linux 9+
- Oracle Linux 8+
- OpenSUSE Tumbleweed

### Documentation
- Подробный README.md с примерами использования
- CONTRIBUTING.md с руководством для разработчиков
- CLAUDE.md для работы с AI-ассистентами
- Лицензия MIT

### Infrastructure
- .gitignore для правильного управления версиями
- Структура проекта для GitHub

---

## Легенда

- `Added` - новые функции
- `Changed` - изменения в существующих функциях
- `Deprecated` - функции, которые скоро будут удалены
- `Removed` - удаленные функции
- `Fixed` - исправления ошибок
- `Security` - исправления уязвимостей

---

## English

All notable changes to the TLScript project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Multiple DNS Provider Support** - Added support for AWS Route53, Google Cloud DNS, and DigitalOcean DNS validation
- **Certbot Integration** - Full Certbot support as alternative to acme.sh with standalone and webroot methods
- **ZeroSSL Support** - Added ZeroSSL as alternative certificate authority via acme.sh
- **Self-Signed Certificates** - New option to generate self-signed certificates for testing
- **Enhanced Menu System** - Reorganized menu with 20+ certificate issuance methods grouped by type

### Certbot Methods (New)
- Certbot Standalone mode (port 80 validation)
- Certbot Webroot mode (existing web server)
- Certbot with Cloudflare DNS plugin
- Certbot with AWS Route53 DNS plugin
- Certbot with Google Cloud DNS plugin
- Certbot with DigitalOcean DNS plugin

### ACME.SH Extensions (New)
- AWS Route53 DNS validation
- Google Cloud DNS validation
- DigitalOcean DNS validation
- ZeroSSL CA integration

## [1.0.0] - 2025-01-24

### Added
- First release of TLScript
- `cert_manager.sh` - main script for SSL certificate management
- HTTP validation support via acme.sh
- DNS validation support via Cloudflare
- Automatic dependency installation (curl, wget, socat, cron)
- Automatic certificate renewal setup via cron
- Interactive menu for ease of use
- Command line support for automation
- Certificate revoke and force renewal functions
- View all installed certificates
- Certificate renewal process logging
- Auto-renewal status check

### Supported OS
- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Fedora 36+
- Arch Linux
- Parch Linux
- Manjaro
- Armbian
- AlmaLinux 9+
- Rocky Linux 9+
- Oracle Linux 8+
- OpenSUSE Tumbleweed

### Documentation
- Detailed README.md with usage examples
- CONTRIBUTING.md with developer guidelines
- CLAUDE.md for AI assistant work
- MIT License

### Infrastructure
- .gitignore for proper version control
- GitHub project structure

---

## Legend

- `Added` - new features
- `Changed` - changes in existing functionality
- `Deprecated` - features that will be removed soon
- `Removed` - removed features
- `Fixed` - bug fixes
- `Security` - security fixes