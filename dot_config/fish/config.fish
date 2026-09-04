if status is-interactive
    set fish_greeting # disable greeting
    fish_vi_key_bindings

    # mise-managed tools + go/cargo toolchain binaries
    fish_add_path ~/.local/bin
    fish_add_path ~/.local/share/mise/shims
    fish_add_path ~/.opencode/bin
    fish_add_path ~/go/bin
    fish_add_path ~/.cargo/bin

    set -gx EDITOR nvim

    starship init fish | source
    zoxide init fish | source
    mise activate fish | source

    atuin init fish | source
    bind -M insert "?" _atuin_ai_question_mark
end
