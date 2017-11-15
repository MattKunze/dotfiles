export ANDROID_HOME=~/Library/Android/sdk
export N_PREFIX="$HOME/n"
export PATH="$PATH:$N_PREFIX/bin"

fish_vi_key_bindings

alias atom='atom-beta'
alias apm='apm-beta'
alias code='code-insiders'

# Show human friendly numbers and colors
alias df='df -h'
alias du='du -h -d 2'

# delete merged branches
alias dmb='git branch --merged | grep -v "\*" | xargs -n 1 git branch -d'

# Homebrew
alias brewu='brew update; and brew upgrade; and brew cleanup; and brew prune; and brew doctor'

abbr -a ni npm i
abbr -a nd rm -rf ./node_modules
abbr -a ns npm start --

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
