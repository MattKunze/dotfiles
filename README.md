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

   Debian/Ubuntu note: also `sudo apt install libatomic1` — the node binary
   needs it (preinstalled on macOS/Fedora/Arch equivalents).

   This installs mise + chezmoi into `~/.local/bin`, applies all dotfiles,
   installs polytoken (via a chezmoi `run_once` script) and every tool in the
   mise config, and creates `~/.config/secrets/`.
   It prompts for machine type (personal/work); for non-interactive runs
   (containers, CI) set `CHEZMOI_MACHINE_TYPE=personal` (or `work`) instead.

3. Finish by hand (one-time, per machine):

   ```sh
   chsh -s "$(command -v fish)"   # make fish your login shell
   gh auth login
   tg auth login <handle>         # tangled.org CLI (OAuth flow, like gh)
   atuin login                    # or: atuin register
   opencode2                      # OpenCode 2 (beta), first-run setup
   polytoken                      # first-run setup
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
| Everything at once      | `mise run update` (abbr: `mr update`) — also updates polytoken |
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
run_once_install-polytoken.sh           installs polytoken if missing (see below)
bootstrap.sh             one-shot onboarding script (not applied to $HOME)
```

## Polytoken

[Polytoken](https://docs.polytoken.dev) is not managed by mise — it isn't in
mise's registry, and it ships its own updater (release channels, launch-time
update checks), which would conflict with `mise upgrade`. Instead it is
installed by the official shell installer into `~/.local/bin` alongside
mise/chezmoi:

- Fresh machines: `bootstrap.sh` → `chezmoi init --apply` runs
  `run_once_install-polytoken.sh`.
- Already-bootstrapped machines: the same script runs on the next
  `chezmoi apply` (installs only if the binary is missing).
- Updates: `mise run update` runs `polytoken update` and regenerates fish
  completions; polytoken also checks for updates on its own at launch.

Fish completions live in `~/.config/fish/completions/polytoken.fish` and fish
loads them automatically.

## Adding a tool

```sh
mise registry | grep <name>     # find its backend
mise use -g <name>              # adds to ~/.config/mise/config.toml
mise install
```

Go-based CLIs without a registry entry can be built from source with the go
backend — e.g. `tg` (tangled.org CLI, module `github.com/alyraffauf/tg`):

```toml
"go:github.com/alyraffauf/tg/cmd/tg" = "latest"   # in dot_config/mise/config.toml
```

`mise install` compiles it with the mise-managed go toolchain, exposes the
binary via shims, and `mise upgrade` keeps it current.

Languages work the same way: mise installs the toolchain (`go`, `rust`,
`node`), and binaries you build land in `~/go/bin` or `~/.cargo/bin`
(both on PATH). Per-project tool versions: `mise use <tool>@<version>`
inside the project (replaces devenv/direnv).

## Testing

`./test/smoke.sh` builds a bare `debian:latest` image containing only the
documented prerequisites (fish, git, curl, libatomic1), runs `bootstrap.sh`
inside it, and verifies the results: dotfiles applied, polytoken installed,
fish starts and loads 67+ abbreviations, mise tools installed, templated
config rendered.

The repo is volume-mounted and used directly as the chezmoi source
(`DOTFILES_LOCAL_SOURCE`), so uncommitted changes are tested. To test the
true onboarding path (clone from origin), comment out the
`DOTFILES_LOCAL_SOURCE` env in `test/smoke.sh` after pushing.

Machine type is forced to `personal` via `CHEZMOI_MACHINE_TYPE` (no TTY in
containers); set `work` to test work-machine rendering.

## Theming

The [warm-burnout](https://github.com/felipefdl/warm-burnout) theme is pulled
by chezmoi as an external (`.chezmoiexternal.yaml`) into
`~/.local/share/warm-burnout` — no submodules, and it refreshes with
`chezmoi update` (weekly; force with `chezmoi update --refresh-externals`).
Symlinks into it are managed like any other dotfile:

- `~/.config/opencode/themes/warm-burnout.json` (theme file, via external)
- `~/.config/opencode/cli.json` (activates the theme + shared UI settings;
  auth lives in the untracked `service.json`)
- `~/.config/ghostty/themes/warm-burnout-{dark,light}` (ghostty config points
  at these via `theme = dark:warm-burnout-dark,light:warm-burnout-light`)

The upstream repo also ships themes for bat, eza, alacritty, and others — to
wire up another app, add a `symlink_` file under the right `dot_config/...`
path pointing into `~/.local/share/warm-burnout/<app>/...` (see existing
examples), then `chezmoi apply`. To use a local fork instead of upstream,
change the `url` in `.chezmoiexternal.yaml` and delete
`~/.local/share/warm-burnout` before the next apply.

## Extending

- New dotfile: `chezmoi add ~/.config/foo/bar.conf`, then `chezmoi apply`.
- Machine-specific bits: wrap content in templates (`.tmpl`) and branch on
  `.is_work` / `.machine_type`, or add data to `.chezmoidata.yaml`.
- Longer term, secrets can move to chezmoi's age/1Password support; the
  `~/.config/secrets/*.fish` mechanism won't need to change.
