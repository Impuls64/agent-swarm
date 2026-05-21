#!/bin/bash
# Swarm Manager для Agent Swarm
# Использование: swarm.sh [list|status|activate|deactivate|reset]

AGENTS_DIR="$HOME/.agents"
MASTER_FILE="$AGENTS_DIR/master.md"
ACTIVE_FILE="$AGENTS_DIR/.active"
WORKERS_DIR="$AGENTS_DIR/workers"
TARGET="$HOME/AGENTS.md"

list_workers() {
    echo "Доступные workers:"
    for f in "$WORKERS_DIR"/*.md; do
        name=$(basename "$f" .md)
        echo "  - $name"
    done
}

status() {
    echo "Активные workers:"
    if [ -f "$ACTIVE_FILE" ] && [ -s "$ACTIVE_FILE" ]; then
        cat "$ACTIVE_FILE" | sed 's/^/  ● /'
    else
        echo "  (none — только мастер)"
    fi
}

activate() {
    shift
    if [ $# -eq 0 ]; then
        echo "❌ Укажи worker(ы) для активации"
        echo "Пример: swarm.sh activate python"
        exit 1
    fi
    
    > "$ACTIVE_FILE"
    for worker in "$@"; do
        if [ ! -f "$WORKERS_DIR/$worker.md" ]; then
            echo "❌ Worker '$worker' не найден в $WORKERS_DIR/"
            list_workers
            exit 1
        fi
        echo "$worker" >> "$ACTIVE_FILE"
    done
    build_agents
    echo "✅ Активированы: $@"
    echo "   Перезапусти opencode или выполни /init для применения"
}

deactivate() {
    shift
    if [ $# -eq 0 ]; then
        echo "❌ Укажи worker(ы) для деактивации"
        exit 1
    fi
    
    for worker in "$@"; do
        if [ -f "$ACTIVE_FILE" ]; then
            sed -i "/^$worker$/d" "$ACTIVE_FILE"
        fi
    done
    build_agents
    echo "✅ Деактивированы: $@"
}

reset() {
    > "$ACTIVE_FILE"
    build_agents
    echo "✅ Сброшено к мастеру (только базовые правила)"
    echo "   Перезапусти opencode или выполни /init для применения"
}

build_agents() {
    cp "$MASTER_FILE" "$TARGET"
    
    if [ -f "$ACTIVE_FILE" ] && [ -s "$ACTIVE_FILE" ]; then
        echo "" >> "$TARGET"
        echo "---" >> "$TARGET"
        echo "" >> "$TARGET"
        echo "# Активные Workers" >> "$TARGET"
        echo "" >> "$TARGET"
        
        while IFS= read -r worker; do
            [ -z "$worker" ] && continue
            echo "<!-- Worker: $worker -->" >> "$TARGET"
            echo "" >> "$TARGET"
            cat "$WORKERS_DIR/$worker.md" >> "$TARGET"
            echo "" >> "$TARGET"
            echo "---" >> "$TARGET"
            echo "" >> "$TARGET"
        done < "$ACTIVE_FILE"
    fi
}

case "${1:-status}" in
    list|ls|l)
        list_workers
        ;;
    status|st|s)
        status
        ;;
    activate|a)
        activate "$@"
        ;;
    deactivate|d)
        deactivate "$@"
        ;;
    reset|r)
        reset
        ;;
    *)
        echo "Agent Swarm Manager"
        echo ""
        echo "Использование: $0 COMMAND [ARGS]"
        echo ""
        echo "Commands:"
        echo "  list, l              Список доступных workers"
        echo "  status, s            Показать активных workers"
        echo "  activate WORKER...   Активировать worker(ы)"
        echo "  deactivate WORKER... Деактивировать worker(ы)"
        echo "  reset, r             Сбросить к мастеру"
        echo ""
        echo "Examples:"
        echo "  $0 activate python"
        echo "  $0 activate python devops"
        echo "  $0 reset"
        exit 1
        ;;
esac
