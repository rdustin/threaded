#!/usr/bin/env bash
set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "$0")/skills" && pwd)"
COMMANDS_DIR="$HOME/.claude/commands"

mkdir -p "$COMMANDS_DIR"

for skill in "$SKILLS_DIR"/*.md; do
  name="$(basename "$skill")"
  target="$COMMANDS_DIR/$name"
  if [[ -e "$target" && ! -L "$target" ]]; then
    echo "skipped (real file, not a symlink): $target"
    continue
  fi
  ln -sf "$skill" "$target"
  echo "linked: $target"
done

count=$(ls "$SKILLS_DIR"/*.md | wc -l | tr -d ' ')
echo ""
echo "$count skills linked to $COMMANDS_DIR"
echo "Run 'git pull' in this repo any time to update them."
