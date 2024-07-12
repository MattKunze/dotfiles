{ config, pkgs, ... }:

{
  programs.fish = {
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_vi_key_bindings
      any-nix-shell fish --info-right | source

      abbr -a hms home-manager switch
      abbr -a nsp nix-shell --packages
      abbr -a nls nix search nixpkgs

      abbr wfy "printf '\eP\$f{\"hook\": \"SourcedRcFileForWarp\", \"value\": { \"shell\": \"fish\" }}\x9c'"

      abbr -a cd z

      abbr -a ll eza -l --icons --git
      abbr -a la eza -la --icons --git
      abbr -a lt eza -lT --icons --git

      abbr -a gs git status
      abbr -a gd git diff
      abbr -a gl git log --graph --date=short
      abbr -a gco git checkout
      abbr -a gf git fetch
      abbr -a gfo git fetch origin --prune
      abbr -a glo git pull origin
      abbr -a gpo git push origin
      abbr -a ga git add -A
      abbr -a gci git commit
      abbr -a gcim git commit -m
      abbr -a gb git branch -v
      abbr -a gnb git checkout -b
      abbr -a gst git stash
      abbr -a gsl git stash list
      abbr -a gsa git stash apply
      abbr -a gsp git stash pop
      abbr -a gsd git stash drop
      abbr -a gm git merge
      abbr -a gms git merge --squash
      abbr -a gfp git format-patch
      abbr -a gr git rebase
      abbr -a gra git rebase --abort
      abbr -a grc git rebase --continue
      abbr -a grs git rebase --skip
      abbr -a gcp git cherry-pick

      abbr -a yb yarn build
      abbr -a yd yarn dev
      abbr -a ys yarn start
      abbr -a yt yarn test
      abbr -a ytw yarn test:watch
      abbr -a yws yarn workspace

      abbr -a dps docker ps
      abbr -a dcu docker compose up
      abbr -a dcd docker compose down
      abbr -a dcr docker compose restart
    '';
  };
}

