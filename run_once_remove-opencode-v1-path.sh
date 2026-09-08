#!/bin/sh
# One-time cleanup of the OpenCode v1 install, which is superseded by
# opencode2 (installed via mise; `oc` abbreviation).
#
# The v1 installer appended its own PATH entry (fish_add_path ~/.opencode/bin)
# to shell configs and to fish's fish_user_paths universal variable. chezmoi
# reverts the config.fish edit (the line was never in the managed file), but
# the universal variable is fish-internal state that chezmoi doesn't manage,
# so remove it here once per machine. ~/.opencode itself is left in place —
# delete it by hand if you want the ~150MB back.
set -eu

V1_BIN="$HOME/.opencode/bin"

if command -v fish >/dev/null 2>&1; then
    fish -c 'set -l p $argv[1]
        set -l i (contains -i -- $p $fish_user_paths)
        or exit 0
        set -e fish_user_paths[$i]
        echo "removed $p from fish_user_paths"' -- "$V1_BIN"
fi
