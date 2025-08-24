# Changelog

[🇷🇺 Русский](#русский) | [🇺🇸 English](#english)

---

## Русский

Все значимые изменения в проекте TLScript будут документированы в этом файле.

Формат основан на [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
и этот проект придерживается [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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