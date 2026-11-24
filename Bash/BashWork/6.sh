#!/bin/bash
# Генерирует случайный пароль длиной 8 символов

LENGTH=8
CHARS='A-Za-z0-9!@#$%^&*'

password=$(tr -dc "$CHARS" < /dev/urandom | head -c "$LENGTH")

echo "Сгенерированный пароль: $password"