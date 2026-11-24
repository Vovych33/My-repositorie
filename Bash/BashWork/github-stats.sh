#!/bin/bash
# Анализатор репозиториев GitHub с цветным выводом
# Использование: ./github-stats.sh tensorflow/tensorflow

# --- Цвета ---
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
NC='\033[0m' # No Color

# --- Проверка аргументов ---
if [ -z "$1" ]; then
    echo -e "${RED}Использование: $0 <owner/repo>${NC}"
    echo -e "Пример: $0 tensorflow/tensorflow"
    exit 1
fi

REPO="$1"

# --- Проверка зависимостей ---
for cmd in curl jq; do
    if ! command -v "$cmd" &>/dev/null; then
        echo -e "${RED}Ошибка: утилита '$cmd' не установлена.${NC}"
        echo -e "Установите: sudo apt install $cmd"
        exit 1
    fi
done

# --- Запрос к GitHub API ---
API_URL="https://api.github.com/repos/$REPO"
RESPONSE=$(curl -s -w "\n%{http_code}" "$API_URL")
HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

# --- Обработка ошибок API ---
case "$HTTP_CODE" in
    200) ;;
    404)
        echo -e "${RED}Ошибка: репозиторий '$REPO' не найден.${NC}"
        exit 1
        ;;
    403)
        echo -e "${RED}Ошибка: превышен лимит запросов к GitHub API.${NC}"
        exit 1
        ;;
    *)
        echo -e "${RED}Ошибка API (HTTP $HTTP_CODE).${NC}"
        exit 1
        ;;
esac

# --- Извлечение данных ---
NAME=$(echo "$BODY" | jq -r '.full_name')
STARS=$(echo "$BODY" | jq -r '.stargazers_count')
FORKS=$(echo "$BODY" | jq -r '.forks_count')
ISSUES=$(echo "$BODY" | jq -r '.open_issues_count')
AUTHOR=$(echo "$BODY" | jq -r '.owner.login')
UPDATED=$(echo "$BODY" | jq -r '.updated_at')

# --- Форматирование чисел с разделителями ---
format_num() {
    printf "%'d" "$1" 2>/dev/null || echo "$1"
}

STARS_FMT=$(format_num "$STARS")
FORKS_FMT=$(format_num "$FORKS")
ISSUES_FMT=$(format_num "$ISSUES")

# --- Цвет issues ---
if [ "$ISSUES" -gt 100 ]; then
    ISSUES_COLOR="$RED"
else
    ISSUES_COLOR="$YELLOW"
fi

# --- "Активность" по дате обновления ---
updated_epoch=$(date -d "$UPDATED" +%s 2>/dev/null)
now_epoch=$(date +%s)
diff_hours=$(( (now_epoch - updated_epoch) / 3600 ))

if [ "$diff_hours" -lt 24 ]; then
    ACTIVITY="Высокая (обновлён $diff_hours ч. назад)"
elif [ "$diff_hours" -lt 168 ]; then
    ACTIVITY="Средняя (обновлён $((diff_hours / 24)) дн. назад)"
else
    ACTIVITY="Низкая (обновлён давно)"
fi

# --- Вывод ---
echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  🚀 GitHub Repository Analyzer         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
echo
echo -e "📦 Репозиторий: ${MAGENTA}$NAME${NC}"
echo -e "${YELLOW}⭐ Звёзды:${NC}       ${YELLOW}$STARS_FMT${NC}"
echo -e "${GREEN}🔀 Форки:${NC}        ${GREEN}$FORKS_FMT${NC}"
echo -e "🐛 Open Issues:  ${ISSUES_COLOR}$ISSUES_FMT${NC}"
echo -e "👤 Автор:        $AUTHOR"
echo -e "📊 Активность:   $ACTIVITY"
echo