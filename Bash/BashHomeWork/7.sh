#!/bin/bash
# Ищет файлы по расширению в текущей директории

read -p "Введите расширение (например, txt): " ext

# Убираем точку, если пользователь её ввёл
ext="${ext#.}"

if [ -z "$ext" ]; then
    echo "Ошибка: расширение не указано!"
    exit 1
fi

echo "Поиск файлов с расширением .$ext в $(pwd):"
found=0
while IFS= read -r -d '' file; do
    echo "  → $file"
    found=$((found + 1))
done < <(find . -maxdepth 1 -type f -name "*.$ext" -print0)

if [ "$found" -eq 0 ]; then
    echo "Файлы с расширением .$ext не найдены."
else
    echo "Всего найдено: $found"
fi