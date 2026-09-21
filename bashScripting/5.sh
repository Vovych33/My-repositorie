#!/bin/bash
# Подсчитывает количество строк в указанном файле

read -p "Введите путь к файлу: " file

if [ ! -f "$file" ]; then
    echo "Ошибка: файл '$file' не найден!"
    exit 1
fi

lines=$(wc -l < "$file")
echo "Количество строк в файле '$file': $lines"