#!/bin/sh
# Runs inside the container: execute the bootstrap from scratch, then verify.
# The repo is mounted at /dotfiles.
set -eu

git config --global --add safe.directory /dotfiles

echo "========================================"
echo "==> running bootstrap.sh"
echo "========================================"
sh /dotfiles/bootstrap.sh

echo ""
echo "========================================"
echo "==> verifying bootstrap results"
echo "========================================"

fail() {
    echo "FAIL: $1" >&2
    exit 1
}

# --- binaries installed by bootstrap
[ -x "$HOME/.local/bin/mise" ] || fail "mise not installed"
[ -x "$HOME/.local/bin/chezmoi" ] || fail "chezmoi not installed"

# --- dotfiles applied
for f in \
    "$HOME/.config/fish/config.fish" \
    "$HOME/.config/fish/conf.d/abbr.fish" \
    "$HOME/.config/fish/conf.d/secrets.fish" \
    "$HOME/.config/git/config" \
    "$HOME/.config/jj/config.toml" \
    "$HOME/.config/starship.toml" \
    "$HOME/.config/atuin/config.toml" \
    "$HOME/.config/mise/config.toml" \
    "$HOME/.config/mise/tasks/update.sh"; do
    [ -f "$f" ] || fail "missing $f"
done
echo "ok: dotfiles applied"

# --- secrets dir prepared
[ -d "$HOME/.config/secrets" ] || fail "secrets dir missing"
[ -f "$HOME/.config/secrets/keys.fish" ] || fail "secrets starter file missing"
echo "ok: secrets dir"

# --- fish configs parse
fish -n "$HOME/.config/fish/config.fish" || fail "config.fish does not parse"
fish -n "$HOME/.config/fish/conf.d/abbr.fish" || fail "abbr.fish does not parse"
fish -n "$HOME/.config/fish/conf.d/secrets.fish" || fail "secrets.fish does not parse"
echo "ok: fish configs parse"

# --- fish starts interactively, sources everything, abbreviations defined
ABBR_COUNT="$(fish -i -c 'abbr --list | count')"
[ "$ABBR_COUNT" -gt 20 ] || fail "expected >20 abbreviations, got $ABBR_COUNT"
echo "ok: fish interactive shell loads, $ABBR_COUNT abbreviations"

# --- mise tools installed by the run_onchange script
TOOL_COUNT="$(fish -i -c 'mise ls --installed | count')"
echo "mise reports $TOOL_COUNT installed tools"
[ "$TOOL_COUNT" -ge 10 ] || fail "expected >=10 mise tools installed, got $TOOL_COUNT"
echo "ok: mise tools installed"

# --- spot check rendered config (personal machine, root container)
grep -q "Matt Kunze" "$HOME/.config/git/config" || fail "git identity not rendered"
grep -q "home.shypan.st/atuin" "$HOME/.config/atuin/config.toml" || fail "atuin sync address not rendered"
echo "ok: templated config rendered (personal)"

# --- warm-burnout theme external + symlinks
[ -f "$HOME/.local/share/warm-burnout/opencode/warm-burnout.json" ] \
    || fail "warm-burnout external not fetched"
[ -f "$(readlink -f "$HOME/.config/opencode/themes/warm-burnout.json")" ] \
    || fail "opencode theme symlink broken"
[ -f "$(readlink -f "$HOME/.config/ghostty/themes/warm-burnout-dark")" ] \
    || fail "ghostty dark theme symlink broken"
[ -f "$(readlink -f "$HOME/.config/ghostty/themes/warm-burnout-light")" ] \
    || fail "ghostty light theme symlink broken"
grep -q "warm-burnout-dark" "$HOME/.config/ghostty/config" \
    || fail "ghostty not using warm-burnout theme"
echo "ok: warm-burnout theme external + symlinks"

echo ""
echo "========================================"
echo "SMOKE TEST PASSED"
echo "========================================"
