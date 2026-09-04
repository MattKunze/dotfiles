# Machine-specific secrets & environment

Files in this directory (`~/.config/secrets/*.fish`) are sourced by fish on every
shell startup (see `~/.config/fish/conf.d/secrets.fish`). They are NOT managed by
chezmoi and never leave this machine — each machine maintains its own set.

Use them for API keys, tokens, and machine-specific env (work proxies, etc.):

```fish
# e.g. ~/.config/secrets/keys.fish
set -gx OPENCODE_GO_API_KEY sk-...

# e.g. ~/.config/secrets/work.fish
set -gx HTTP_PROXY http://proxy.example.com:8080
set -gx HTTPS_PROXY http://proxy.example.com:8080
set -gx NO_PROXY localhost,127.0.0.1
```

Later, these can migrate to first-class chezmoi secret management
(age encryption, 1Password, etc.) without changing how fish consumes them.
