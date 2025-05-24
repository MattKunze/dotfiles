{ ... }:

{
  programs.nushell = {
    enable = true;

    # https://github.com/nushell/nushell/issues/5552#issuecomment-2113935091
    extraConfig = ''
      let abbreviations = {
        la: 'ls -la'
        ll: 'ls -l'
        el: 'eza -l --icons --git'
        ea: 'eza -la --icons --git'
        et: 'eza -lT --icons --git'

        hms: 'home-manager switch'
        nsp: 'nix-shell --packages'
        nls: 'nix search nixpkgs'

        cat: 'bat'
        cd: 'z'
        find: 'fd'

        gs: 'git status'
        gd: 'git diff'
        gl: 'git log --graph --date=short --oneline'
        gco: 'git checkout'
        gf: 'git fetch'
        gfo: 'git fetch origin --prune'
        glo: 'git pull origin --autostash'
        gpo: 'git push origin'
        ga: 'git add -A'
        gci: 'git commit'
        gcim: 'git commit -m'
        gb: 'git branch -v'
        gnb: 'git checkout -b'
        gst: 'git stash'
        gsl: 'git stash list'
        gsa: 'git stash apply'
        gsp: 'git stash pop'
        gsd: 'git stash drop'
        gm: 'git merge'
        gms: 'git merge --squash'
        gfp: 'git format-patch'
        gr: 'git rebase'
        gra: 'git rebase --abort'
        grc: 'git rebase --continue'
        grs: 'git rebase --skip'
        gcp: 'git cherry-pick'

        js: 'jj st'
        jl: 'jj log'
        jn: 'jj new'
        jd: 'jj describe -m'
        ja: 'jj abandon'

        yb: 'yarn build'
        yd: 'yarn dev'
        ys: 'yarn start'
        yt: 'yarn test'
        ytw: 'yarn test:watch'
        yws: 'yarn workspace'

        cr: 'cargo run'
        ca: 'cargo add'

        dps: 'docker ps'
        dcu: 'docker compose up'
        dcd: 'docker compose down'
        dcr: 'docker compose restart'
      }

      $env.config = {
        keybindings: [
          {
            name: abbr_menu
            modifier: none
            keycode: enter
            mode: [emacs, vi_normal, vi_insert]
            event: [
              { send: menu name: abbr_menu }
              { send: enter }
            ]
          }
          {
            name: abbr_menu
            modifier: none
            keycode: space
            mode: [emacs, vi_normal, vi_insert]
            event: [
              { send: menu name: abbr_menu }
              { edit: insertchar value: ' '}
            ]
          }
        ]

        menus: [
          {
            name: abbr_menu
            only_buffer_difference: false
            marker: none
            type: {
              layout: columnar
              columns: 1
              col_width: 20
              col_padding: 2
            }
            style: {
              text: green
              selected_text: green_reverse
              description_text: yellow
            }
            source: { |buffer, position|
              let match = $abbreviations | columns | where $it == $buffer
              if ($match | is-empty) {
                { value: $buffer }
              } else {
                { value: ($abbreviations | get $match.0) }
              }
            }
          }
        ]

        show_banner: false
      }
    '';
  };
}
