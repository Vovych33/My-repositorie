#!/bin/bash
# Создаёт структуру папок для веб-проекта

read -p "Введите имя проекта: " project

if [ -z "$project" ]; then
    echo "Ошибка: имя проекта не может быть пустым!"
    exit 1
fi

if [ -d "$project" ]; then
    echo "Ошибка: папка '$project' уже существует!"
    exit 1
fi

mkdir -p "$project/css" "$project/js"

cat > "$project/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Мой проект</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <h1>Привет, мир!</h1>
    <script src="js/script.js"></script>
</body>
</html>
EOF

cat > "$project/css/style.css" <<'EOF'
body {
    font-family: Arial, sans-serif;
    margin: 20px;
}
EOF

cat > "$project/js/script.js" <<'EOF'
console.log("Скрипт загружен");
EOF

echo "Структура проекта '$project' создана:"
find "$project" | sort