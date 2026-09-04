#!/usr/bin/env bash
# mise task: update everything (tools + dotfiles)
# usage: mise run update
set -euo pipefail

echo "==> upgrading mise"
mise self-update

echo "==> upgrading tools"
mise upgrade

echo "==> updating dotfiles (chezmoi update = pull + apply)"
chezmoi update

# Polytoken is not mise-managed; it updates itself. Regenerate fish
# completions afterwards since they ship with the binary.
if command -v polytoken >/dev/null 2>&1; then
    echo "==> updating polytoken"
    polytoken update
    mkdir -p "$HOME/.config/fish/completions"
    polytoken completions fish > "$HOME/.config/fish/completions/polytoken.fish"
fi
