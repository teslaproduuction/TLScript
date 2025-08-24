# Contributing to TLScript

[🇷🇺 Русский](#русский) | [🇺🇸 English](#english)

---

## Русский

Спасибо за интерес к улучшению TLScript! Мы ценим вклад сообщества.

## 🤝 Как внести вклад

### Сообщения об ошибках

Если вы нашли ошибку:

1. Убедитесь, что ошибка не была уже сообщена в [Issues](https://github.com/teslaproduuction/TLScript/issues)
2. Создайте новый Issue с подробным описанием:
   - Используемая ОС и версия
   - Шаги для воспроизведения
   - Ожидаемое поведение
   - Фактическое поведение
   - Логи ошибок

### Предложения по улучшению

Для новых функций или улучшений:

1. Создайте Issue с тегом "enhancement"
2. Опишите предлагаемую функцию
3. Объясните, зачем она нужна
4. Предложите возможную реализацию

### Pull Requests

1. **Fork** репозитория
2. Создайте **feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit** ваши изменения (`git commit -m 'Add some AmazingFeature'`)
4. **Push** в branch (`git push origin feature/AmazingFeature`)
5. Откройте **Pull Request**

## 📋 Стандарты кода

### Bash-скрипты
- Используйте `#!/bin/bash` в качестве shebang
- Добавляйте комментарии для сложной логики
- Используйте `set -e` для остановки на ошибках в критических частях
- Проверяйте возвращаемые значения команд
- Используйте `[[ ]]` вместо `[ ]` для тестов

### Стиль кодирования
```bash
# Хорошо
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# Плохо  
if [ -f $file ]
then
echo "File exists"
fi
```

### Функции
```bash
# Именуйте функции описательно
install_dependencies() {
    local package="$1"
    # код функции
}
```

## 🧪 Тестирование

Перед отправкой PR:

1. Протестируйте скрипт на чистой системе
2. Убедитесь, что все функции работают
3. Проверьте совместимость с разными ОС
4. Проверьте, что не сломались существующие функции

## 📝 Документация

- Обновляйте README.md при изменении функциональности
- Добавляйте примеры использования для новых функций
- Документируйте любые новые зависимости

## 🔍 Проверочный список для PR

- [ ] Код протестирован на Ubuntu/Debian
- [ ] Код протестирован на CentOS/RHEL
- [ ] Обновлена документация
- [ ] Добавлены комментарии к сложному коду
- [ ] Нет конфликтов с main веткой
- [ ] Commit сообщения описательные

## 💬 Вопросы

Если у вас есть вопросы, создайте Issue с тегом "question" или свяжитесь с мейнтейнерами.

---

Спасибо за ваш вклад! 🙏

---

## English

Thank you for your interest in improving TLScript! We value community contributions.

## 🤝 How to Contribute

### Bug Reports

If you found a bug:

1. Make sure the bug hasn't been already reported in [Issues](https://github.com/teslaproduuction/TLScript/issues)
2. Create a new Issue with detailed description:
   - Used OS and version
   - Steps to reproduce
   - Expected behavior
   - Actual behavior
   - Error logs

### Feature Suggestions

For new features or improvements:

1. Create an Issue with "enhancement" tag
2. Describe the proposed feature
3. Explain why it's needed
4. Suggest possible implementation

### Pull Requests

1. **Fork** the repository
2. Create a **feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit** your changes (`git commit -m 'Add some AmazingFeature'`)
4. **Push** to branch (`git push origin feature/AmazingFeature`)
5. Open a **Pull Request**

## 📋 Code Standards

### Bash Scripts
- Use `#!/bin/bash` as shebang
- Add comments for complex logic
- Use `set -e` to stop on errors in critical parts
- Check command return values
- Use `[[ ]]` instead of `[ ]` for tests

### Coding Style
```bash
# Good
if [[ -f "$file" ]]; then
    echo "File exists"
fi

# Bad
if [ -f $file ]
then
echo "File exists"
fi
```

### Functions
```bash
# Name functions descriptively
install_dependencies() {
    local package="$1"
    # function code
}
```

## 🧪 Testing

Before submitting PR:

1. Test the script on a clean system
2. Ensure all functions work
3. Check compatibility with different OS
4. Verify existing functions aren't broken

## 📝 Documentation

- Update README.md when changing functionality
- Add usage examples for new functions
- Document any new dependencies

## 🔍 PR Checklist

- [ ] Code tested on Ubuntu/Debian
- [ ] Code tested on CentOS/RHEL
- [ ] Documentation updated
- [ ] Comments added to complex code
- [ ] No conflicts with main branch
- [ ] Descriptive commit messages

## 💬 Questions

If you have questions, create an Issue with "question" tag or contact maintainers.

---

Thank you for your contribution! 🙏