# Machine-specific environment variables and secrets.
# Nothing in this repo: each machine keeps its own files in ~/.config/secrets/.
# Files must be fish syntax, e.g.:
#   set -gx OPENCODE_GO_API_KEY sk-...
#   set -gx HTTP_PROXY http://proxy.example.com:8080
#   set -gx NO_PROXY localhost,127.0.0.1
if test -d $HOME/.config/secrets
    for f in $HOME/.config/secrets/*.fish
        source $f
    end
end
