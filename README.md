# dotfiles

Dotfiles managed by [chezmoi](https://www.chezmoi.io), tools managed by
[mise](https://mise.jdx.dev). Works on macOS, Linux, and WSL.

## Onboarding a new machine

1. Install fish manually (it's the one thing kept outside this toolchain):

   ```sh
   # macOS (if you have brew):
   brew install fish
   # Debian/Ubuntu: sudo apt install fish
   # Fedora:        sudo dnf install fish
   # Arch:          sudo pacman -S fish
   ```

2. Clone and bootstrap:

   ```sh
   git clone https://github.com/MattKunze/dotfiles.git && cd dotfiles
   ./bootstrap.sh
   ```

   This installs mise + chezmoi into `~/.local/bin`, applies all dotfiles,
   installs every tool in the mise config, and creates `~/.config/secrets/`.

3. Finish by hand (one-time, per machine):

   ```sh
   chsh -s "$(command -v fish)"   # make fish your login shell
   gh auth login
   atuin login                    # or: atuin register
   opencode                       # first-run setup
   ```

   Machine-specific keys/env go in `~/.config/secrets/*.fish` (fish syntax,
   sourced at shell startup; see `~/.config/secrets/README.md`).

## Daily use

| Task                    | Command                                        |
| ----------------------- | ---------------------------------------------- |
| Apply dotfile changes   | `chezmoi apply` (abbr: `cma`)                  |
| Edit a managed file     | `chezmoi edit <path>` then `chezmoi apply`     |
| Pull + apply everywhere | `chezmoi update` (abbr: `cmu`)                 |
| See what would change   | `chezmoi diff` (abbr: `cmd`)                   |
| Install/upgrade tools   | `mise install` (abbr: `mi`) / `mise upgrade`   |
| Everything at once      | `mise run update` (abbr: `mr update`)          |
| Fish abbreviations      | all in `dot_config/fish/conf.d/abbr.fish`      |

## Layout

```
.chezmoi.toml.tmpl       prompts for machine type (personal/work) on init
.chezmoidata.yaml        shared defaults (identities, atuin sync servers)
dot_config/              files applied to ~/.config/
  fish/                  shell config; abbreviations in conf.d/abbr.fish
  git/, jj/              identity templated per machine (personal vs work)
  atuin/                 sync address templated per machine
  ghostty/, gh/          terminal + github cli
  mise/config.toml       global tool list (installed by mise install)
  mise/tasks/            mise tasks (mise run update, ...)
  secrets/               README only — actual secret files are untracked
run_onchange_install-packages.sh.tmpl   re-runs `mise install` on config change
bootstrap.sh             one-shot onboarding script (not applied to $HOME)
```

## Adding a tool

```sh
mise registry | grep <name>     # find its backend
mise use -g <name>              # adds to ~/.config/mise/config.toml
mise install
```

Languages work the same way: mise installs the toolchain (`go`, `rust`,
`node`), and binaries you build land in `~/go/bin` or `~/.cargo/bin`
(both on PATH). Per-project tool versions: `mise use <tool>@<version>`
inside the project (replaces devenv/direnv).

## Extending

- New dotfile: `chezmoi add ~/.config/foo/bar.conf`, then `chezmoi apply`.
- Machine-specific bits: wrap content in templates (`.tmpl`) and branch on
  `.is_work` / `.machine_type`, or add data to `.chezmoidata.yaml`.
- Longer term, secrets can move to chezmoi's age/1Password support; the
  `~/.config/secrets/*.fish` mechanism won't need to change.
