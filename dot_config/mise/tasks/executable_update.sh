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
