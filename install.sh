#!/bin/bash
# Kimi Swarm — One-command installer
# Usage: ./install.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$HOME/.agents"

echo "🚀 Kimi Swarm Installer"
echo "======================"

# Check if we're in ~/.agents
if [ "$REPO_DIR" != "$AGENTS_DIR" ]; then
    echo "⚠️  Warning: Repository not in ~/.agents"
    echo "   Current: $REPO_DIR"
    echo "   Expected: $AGENTS_DIR"
    echo ""
    read -p "Move to ~/.agents? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
        mkdir -p "$(dirname "$AGENTS_DIR")"
        mv "$REPO_DIR" "$AGENTS_DIR"
        cd "$AGENTS_DIR"
        echo "✅ Moved to ~/.agents"
    else
        echo "❌ Please move to ~/.agents manually:"
        echo "   mv $REPO_DIR ~/.agents"
        exit 1
    fi
else
    cd "$AGENTS_DIR"
fi

# Make scripts executable
chmod +x swarm.sh
echo "✅ Scripts made executable"

# Create symlink for master AGENTS.md
if [ -L "$HOME/AGENTS.md" ] || [ -f "$HOME/AGENTS.md" ]; then
    rm -f "$HOME/AGENTS.md"
fi
ln -s "$AGENTS_DIR/master.md" "$HOME/AGENTS.md"
echo "✅ Created ~/AGENTS.md → master.md"

# Create symlinks for workers inside ~/.agents/
for worker in "$AGENTS_DIR"/workers/*.md; do
    name=$(basename "$worker" .md)
    link="$AGENTS_DIR/AGENTS_${name}.md"
    if [ -L "$link" ] || [ -f "$link" ]; then
        rm -f "$link"
    fi
    ln -s "$worker" "$link"
done
echo "✅ Created AGENTS_*.md symlinks in ~/.agents/"

# Remove old ~/AGENTS_*.md symlinks (cleanup)
for link in "$HOME"/AGENTS_*.md; do
    if [ -L "$link" ]; then
        rm -f "$link"
    fi
done
echo "✅ Cleaned up old ~/AGENTS_*.md symlinks"

# Initialize .active file
if [ ! -f "$AGENTS_DIR/.active" ]; then
    touch "$AGENTS_DIR/.active"
    echo "✅ Initialized .active file"
fi

# Git config (if not set)
if ! git config user.name >/dev/null 2>&1; then
    git config user.name "Kimi Swarm"
    git config user.email "agent@swarm.local"
    echo "✅ Git user configured"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "Structure:"
echo "  ~/AGENTS.md              → ~/.agents/master.md"
echo "  ~/.agents/AGENTS_*.md    → workers/*.md"
echo ""
echo "Quick start:"
echo "  ~/.agents/swarm.sh list           # List workers"
echo "  ~/.agents/swarm.sh activate python # Activate Python worker"
echo "  ~/.agents/swarm.sh status         # Check status"
echo ""
echo "Then restart opencode or run /init"
echo ""
echo "Create new project:"
echo "  mkdir ~/projects/my-project"
echo "  cp ~/.agents/master.md ~/projects/my-project/AGENTS.md"
echo "  cp ~/.agents/workers/python.md ~/projects/my-project/backend/AGENTS.md"
