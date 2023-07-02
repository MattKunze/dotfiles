if status is-interactive
  # Commands to run in interactive sessions can go here

  any-nix-shell fish --info-right | source
  direnv hook fish | source
  fish_vi_key_bindings
  starship init fish | source

  set PATH $HOME/bin $PATH /opt/homebrew/bin

  # Show human friendly numbers and colors
  alias df='df -h'
  alias du='du -h -d 2'

  alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'

  alias brie='ssh brie.shypan.st'
  alias four='ssh four.shypan.st'
  alias hole='ssh hole.shypan.st'
  alias ubnt='ssh ubnt@ubnt.shypan.st'
  alias zero='ssh pi@zero.shypan.st'

  abbr -a hm home-manager
  abbr -a hms home-manager switch
  abbr -a ns nix-shell
  abbr -a nsp nix-shell --packages

  abbr -a code code-insiders

  abbr -a el exa -l --icons --git
  abbr -a ea exa -la --icons --git

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
end
