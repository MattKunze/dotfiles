#!/bin/sh
# Installs Polytoken on machines that were bootstrapped before it was added
# (bootstrap.sh gets it via chezmoi init --apply running this script too).
#
# Polytoken is not in mise's registry and manages its own updates
# (`polytoken update`, plus a launch-time update check), so it is installed
# alongside mise/chezmoi in ~/.local/bin rather than managed by mise. This
# script installs it once if missing; updates happen via `mise run update`
# (mr update) and Polytoken's own updater.

set -eu

BIN_DIR="$HOME/.local/bin"
BIN="$BIN_DIR/polytoken"

if [ -x "$BIN" ] || command -v polytoken >/dev/null 2>&1; then
    echo "polytoken already installed, skipping (updates run via 'mr update')"
    exit 0
fi

echo "==> installing polytoken ($BIN_DIR, latest channel)"
# The installer uses bash syntax (Debian's /bin/sh is dash), so run it with bash.
curl -fsS https://get.polytoken.dev | env PT_INSTALL_DIR="$BIN_DIR" bash

echo "==> generating fish completions"
mkdir -p "$HOME/.config/fish/completions"
"$BIN" completions fish > "$HOME/.config/fish/completions/polytoken.fish"
