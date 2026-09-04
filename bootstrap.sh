#!/bin/sh
# Dotfiles bootstrap: run from inside a fresh clone on a new machine.
#
#   git clone https://github.com/MattKunze/dotfiles.git && cd dotfiles && ./bootstrap.sh
#
# Installs mise + chezmoi into ~/.local/bin, applies all dotfiles, and installs
# tools declared in ~/.config/mise/config.toml. Fish itself is a prerequisite
# (installed manually per machine — see README).

set -eu

REPO_URL="${1:-}"
if [ -z "$REPO_URL" ]; then
    REPO_URL="$(git -C "$(dirname "$0")" remote get-url origin 2>/dev/null || echo "")"
fi
if [ -z "$REPO_URL" ]; then
    echo "error: could not determine repo url; pass it as an argument:" >&2
    echo "  ./bootstrap.sh <repo-url>" >&2
    exit 1
fi
BRANCH="$(git -C "$(dirname "$0")" branch --show-current 2>/dev/null || echo "mise-chezmoi")"

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

log() { printf '\n==> %s\n' "$1"; }

log "checking prerequisites"
if ! command -v git >/dev/null 2>&1; then
    echo "error: git is required" >&2
    exit 1
fi
if ! command -v fish >/dev/null 2>&1; then
    echo "error: fish is not installed. Install it manually first, e.g.:" >&2
    echo "  macOS:   brew install fish            (or see README for alternatives)" >&2
    echo "  Debian/Ubuntu: sudo apt install fish" >&2
    echo "  Fedora:  sudo dnf install fish" >&2
    echo "  Arch:    sudo pacman -S fish" >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "error: curl is required (used to download mise and chezmoi)" >&2
    exit 1
fi

log "installing mise"
if ! command -v mise >/dev/null 2>&1 && [ ! -x "$BIN_DIR/mise" ]; then
    curl -fsSL https://mise.run | MISE_INSTALL_PATH="$BIN_DIR/mise" sh
fi

log "installing chezmoi"
if ! command -v chezmoi >/dev/null 2>&1 && [ ! -x "$BIN_DIR/chezmoi" ]; then
    curl -fsSL https://git.io/chezmoi | sh -s -- -b "$BIN_DIR"
fi

log "applying dotfiles (branch: $BRANCH)"
if [ -n "${DOTFILES_LOCAL_SOURCE:-}" ]; then
    # test/dev mode: use a local checkout as the chezmoi source instead of
    # cloning $REPO_URL (lets you verify uncommitted changes)
    "$BIN_DIR/chezmoi" init --apply --branch "$BRANCH" --source "$DOTFILES_LOCAL_SOURCE"
else
    "$BIN_DIR/chezmoi" init --apply --branch "$BRANCH" "$REPO_URL"
fi

log "preparing secrets dir (~/.config/secrets)"
mkdir -p "$HOME/.config/secrets"
if [ ! -e "$HOME/.config/secrets/keys.fish" ]; then
    printf '# add machine-specific keys/env here, fish syntax:\n# set -gx EXAMPLE_API_KEY ...\n' \
        > "$HOME/.config/secrets/keys.fish"
fi

log "done! next steps (manual, per machine):"
cat <<EOF
  - make fish your login shell:  chsh -s "$(command -v fish)"
  - open a new fish shell
  - authenticate services as needed:
      gh auth login
      atuin login            (or: atuin register)
      opencode               (first run does setup)
  - add secrets to ~/.config/secrets/*.fish
EOF
