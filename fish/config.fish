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
