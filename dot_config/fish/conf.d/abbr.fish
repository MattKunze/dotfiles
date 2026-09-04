# Centralized fish abbreviations.
# Abbreviations expand inline as you type; edit freely, `cm && cma` to redeploy.

# --- dotfile/tool management -------------------------------------------------
abbr -a cm chezmoi
abbr -a cma chezmoi apply
abbr -a cmd chezmoi diff
abbr -a cmu chezmoi update
abbr -a cme chezmoi edit
abbr -a mi mise install
abbr -a mu mise upgrade
abbr -a mr mise run
abbr -a j just

# --- everyday ----------------------------------------------------------------
abbr -a cat bat
abbr -a cd z
abbr -a find fd
abbr -a oc opencode2
abbr -a pt polytoken
abbr -a we watchexec

abbr -a ll eza -l --icons --git
abbr -a la eza -la --icons --git
abbr -a lt eza -lT --icons --git

# --- git ---------------------------------------------------------------------
abbr -a gs git status
abbr -a gd git diff
abbr -a gl git log --graph --date=short --oneline
abbr -a gco git checkout
abbr -a gsw git switch
abbr -a gf git fetch
abbr -a gfo git fetch origin --prune
abbr -a glo git pull origin --autostash
abbr -a gpo git push origin
abbr -a ga git add -A
abbr -a gci git commit
abbr -a gcim git commit -m
abbr -a gb git branch -v
abbr -a gnb git switch -c
abbr -a gst git stash -u
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

# --- jujutsu -----------------------------------------------------------------
abbr -a js jj st
abbr -a jl jj log
abbr -a jn jj new
abbr -a jd jj describe -m
abbr -a ja jj abandon

# --- yarn --------------------------------------------------------------------
abbr -a yb yarn build
abbr -a yd yarn dev
abbr -a ys yarn start
abbr -a yt yarn test
abbr -a ytw yarn test:watch
abbr -a yws yarn workspace

# --- language runtimes -------------------------------------------------------
abbr -a cr cargo run
abbr -a ca cargo add

abbr -a dr deno run
abbr -a da deno add

abbr -a ip uv run ipython

# --- docker ------------------------------------------------------------------
abbr -a dps docker ps
abbr -a dc docker compose
abbr -a dcb docker build
abbr -a dcu docker compose up
abbr -a dcd docker compose down
abbr -a dcn docker compose run
abbr -a dcr docker compose restart
