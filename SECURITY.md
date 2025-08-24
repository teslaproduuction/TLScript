# Security Policy

[🇷🇺 Русский](#русский) | [🇺🇸 English](#english)

---

## Русский

## Поддерживаемые версии

Мы предоставляем обновления безопасности для следующих версий TLScript:

| Версия | Поддерживается          |
| ------- | ---------------------- |
| 1.0.x   | :white_check_mark: |

## Сообщения об уязвимостях

Если вы обнаружили уязвимость безопасности в TLScript, мы просим вас сообщить о ней ответственно.

### Как сообщить

1. **НЕ** создавайте публичный Issue для уязвимостей безопасности
2. Отправьте email с описанием уязвимости на: [security@example.com] (замените на реальный email)
3. Или создайте приватный Security Advisory на GitHub

### Что включить в отчет

- Описание уязвимости
- Шаги для воспроизведения
- Возможное влияние
- Предлагаемое решение (если есть)
- Ваши контактные данные

### Что ожидать

- Подтверждение получения вашего отчета в течение 48 часов
- Начальную оценку в течение 7 дней
- Регулярные обновления о прогрессе
- Уведомление о релизе исправления

## Политика безопасности

### Принципы безопасности TLScript

1. **Минимальные привилегии**: Скрипт требует root права только когда необходимо
2. **Проверка входных данных**: Все пользовательские вводы проверяются
3. **Безопасное хранение**: Сертификаты хранятся в защищенной директории `/root/cert/`
4. **Официальные источники**: Используются только официальные репозитории и источники

### Рекомендации по безопасности

#### Для пользователей:

- Всегда запускайте скрипт от имени root
- Регулярно обновляйте скрипт до последней версии
- Проверяйте целостность скачанного файла
- Используйте сильные пароли для Cloudflare API
- Регулярно проверяйте логи продления сертификатов

#### Загрузка скрипта:
```bash
# Безопасная загрузка с проверкой
curl -L https://github.com/teslaproduuction/TLScript/raw/main/cert_manager.sh -o cert_manager.sh
# Проверьте содержимое перед выполнением
less cert_manager.sh
chmod +x cert_manager.sh
```

#### Мониторинг:
```bash
# Регулярно проверяйте логи
tail -f /var/log/acme_renewal.log

# Проверяйте cron задачи
crontab -l | grep acme
```

### Известные ограничения

1. Скрипт требует интернет-соединение для загрузки acme.sh
2. Временно открывает порт 80 для HTTP валидации
3. Сохраняет API ключи Cloudflare в переменных окружения

### Обновления безопасности

Критические обновления безопасности будут выпущены как можно скорее. Подпишитесь на уведомления репозитория для получения обновлений.

---

Спасибо за помощь в обеспечении безопасности TLScript!

---

## English

## Supported Versions

We provide security updates for the following versions of TLScript:

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting Vulnerabilities

If you discover a security vulnerability in TLScript, we ask you to report it responsibly.

### How to Report

1. **DO NOT** create a public Issue for security vulnerabilities
2. Send an email with vulnerability description to: [security@example.com] (replace with real email)
3. Or create a private Security Advisory on GitHub

### What to Include in Report

- Vulnerability description
- Steps to reproduce
- Possible impact
- Suggested solution (if any)
- Your contact information

### What to Expect

- Acknowledgment of your report within 48 hours
- Initial assessment within 7 days
- Regular updates on progress
- Notification of fix release

## Security Policy

### TLScript Security Principles

1. **Minimal Privileges**: Script requires root rights only when necessary
2. **Input Validation**: All user inputs are validated
3. **Secure Storage**: Certificates are stored in secure `/root/cert/` directory
4. **Official Sources**: Only official repositories and sources are used

### Security Recommendations

#### For Users:

- Always run script as root
- Regularly update script to latest version
- Verify integrity of downloaded file
- Use strong passwords for Cloudflare API
- Regularly check certificate renewal logs

#### Script Download:
```bash
# Safe download with verification
curl -L https://github.com/teslaproduuction/TLScript/raw/main/cert_manager.sh -o cert_manager.sh
# Check content before execution
less cert_manager.sh
chmod +x cert_manager.sh
```

#### Monitoring:
```bash
# Regularly check logs
tail -f /var/log/acme_renewal.log

# Check cron tasks
crontab -l | grep acme
```

### Known Limitations

1. Script requires internet connection to download acme.sh
2. Temporarily opens port 80 for HTTP validation
3. Saves Cloudflare API keys in environment variables

### Security Updates

Critical security updates will be released as soon as possible. Subscribe to repository notifications for updates.

---

Thank you for helping secure TLScript!