#!/bin/bash
# Справочник workers Agent Swarm.
# Активация больше не нужна: master.md + LESSONS.md грузятся
# автоматически через "instructions" в ~/.config/opencode/opencode.jsonc.
# Workers читай по Router-таблице в master.md.

AGENTS_DIR="$HOME/.agents"
WORKERS_DIR="$AGENTS_DIR/workers"

case "${1:-list}" in
    list|ls|l)
        echo "Доступные workers (читать по запросу, см. Router в master.md):"
        for f in "$WORKERS_DIR"/*.md; do
            name=$(basename "$f" .md)
            size=$(wc -l < "$f")
            echo "  - $name ($size строк)"
        done
        ;;
    *)
        echo "Agent Swarm — справочник workers"
        echo ""
        echo "Использование: $0 list"
        echo ""
        echo "Активация/deactivate удалены: правила грузятся через opencode.jsonc (instructions)."
        echo "После правки workers — перезапусти opencode (/init)."
        ;;
esac
