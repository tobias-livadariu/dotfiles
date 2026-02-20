# To apply new aliases, run:
# source ~/repos/dotfiles/aliases.zsh

# Git aliases
alias g="git"
alias gs="git status"
# alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcmsg="git commit -m"
alias gd="git diff"
# grs     = git restore
# grss    = git restore --source
# grst    = git restore --staged
# alias gf="git fetch"
alias gpull="git pull"
alias gpush="git push"
alias gcl="git clone"

# Git workflow functions
# Add all, commit with message, and push (sets upstream if needed)
gsend() {
  if [[ -z "$1" ]]; then
    echo "Usage: gsend \"commit message\""
    return 1
  fi
  git add --all && git commit -m "$1" && git push -u origin HEAD
}

# Branch management
alias gb="git branch"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcom="git checkout main"
gob() {
  [[ -z "$1" ]] && echo "Usage: gob <branch>" && return 1
  git fetch origin "$1" && git checkout "$1"
}

# Stashing
alias gstp="git stash push -m"
alias gstpu="git stash push -u -m"
alias gstl="git stash list"
alias gstdrop="git stash drop"
alias gstpop="git stash pop"

# Stash push with message, then apply nth stash (defaults to 0, clamps to last stash)
gstpa() {
  [[ -z "$1" ]] && echo "Usage: gstpa \"message\" [stash-index]" && return 1
  git stash push -m "$1" || return 1
  local count=$(git stash list | wc -l | tr -d ' ')
  local idx=${2:-0}
  (( idx >= count )) && idx=$((count - 1))
  git stash apply "stash@{$idx}"
}

# Stash push -u with message, then apply nth stash (defaults to 0, clamps to last stash)
gstpua() {
  [[ -z "$1" ]] && echo "Usage: gstpua \"message\" [stash-index]" && return 1
  git stash push -u -m "$1" || return 1
  local count=$(git stash list | wc -l | tr -d ' ')
  local idx=${2:-0}
  (( idx >= count )) && idx=$((count - 1))
  git stash apply "stash@{$idx}"
}

# Apply nth stash (zero-indexed, defaults to 0, clamps to last stash)
gstap() {
  local count=$(git stash list | wc -l | tr -d ' ')
  [[ $count -eq 0 ]] && echo "No stashes" && return
  local idx=${1:-0}
  (( idx >= count )) && idx=$((count - 1))
  git stash apply "stash@{$idx}"
}

# View nth stash summary (zero-indexed, defaults to 0, clamps to last stash)
gstv() {
  local count=$(git stash list | wc -l | tr -d ' ')
  [[ $count -eq 0 ]] && echo "No stashes" && return
  local idx=${1:-0}
  (( idx >= count )) && idx=$((count - 1))
  git stash show "stash@{$idx}"
}

# View nth stash patch/diff (zero-indexed, defaults to 0, clamps to last stash)
gstvp() {
  local count=$(git stash list | wc -l | tr -d ' ')
  [[ $count -eq 0 ]] && echo "No stashes" && return
  local idx=${1:-0}
  (( idx >= count )) && idx=$((count - 1))
  git stash show -p "stash@{$idx}"
}

# Log viewing
alias glo="git log"
alias glog="git log --oneline --graph --decorate"
alias glast="git log -1 HEAD --stat"

# Git open file functions
# Open nth modified file (zero-indexed, defaults to 0, clamps to last file)
gom() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff HEAD --name-only)"})
  local count=${#files[@]}
  [[ $count -eq 0 || -z "${files[1]}" ]] && echo "No modified files" && return
  local idx=$((${1:-0} + 1))
  (( idx > count )) && idx=$count
  cursor "$root/${files[$idx]}"
}

# Open all modified files
goma() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff HEAD --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No modified files"
}

# Open nth staged file (zero-indexed, defaults to 0, clamps to last file)
gos() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff --cached --name-only)"})
  local count=${#files[@]}
  [[ $count -eq 0 || -z "${files[1]}" ]] && echo "No staged files" && return
  local idx=$((${1:-0} + 1))
  (( idx > count )) && idx=$count
  cursor "$root/${files[$idx]}"
}

# Open all staged files
gosa() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff --cached --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No staged files"
}

# Open nth unstaged file (zero-indexed, defaults to 0, clamps to last file)
gou() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff --name-only)"})
  local count=${#files[@]}
  [[ $count -eq 0 || -z "${files[1]}" ]] && echo "No unstaged files" && return
  local idx=$((${1:-0} + 1))
  (( idx > count )) && idx=$count
  cursor "$root/${files[$idx]}"
}

# Open all unstaged files
goua() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No unstaged files"
}

# Open all changed files (staged + unstaged) in cursor
goc() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff HEAD --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No changed files"
}

# Dev aliases
alias d="dev"
alias dcd="dev cd"
alias dcd="dev cd //"
alias dcds="dev cd shopify"
alias dcda="dev cd marketing-attribution"
alias dcdaw="dev cd admin-web"
alias dcdmae="dev cd merchant-analytics-etl"
alias dcdmaa="dev cd merchant-analytics-api"
cdr() {
  cd ~/repos/${1:+$1}
}
alias cdss="cd ~/repos/scatter-scout"
sscout() {
  (
    unset GEM_HOME GEM_PATH GEM_ROOT
    chruby 3.4.8
    cd ~/repos/scatter-scout
    bundle exec ruby bin/sscout "$@"
  )
}
alias dt="dev test"
alias dtc="dev test --changedSince=main"
alias du="dev up"
alias dd="dev down"
alias ds="dev server"
alias dop="dev open"
alias doa="dev open app"
alias doi="dev open internal"
alias dog="dev open graphiql"
alias dco="dev console"

# Admin-web aliases
alias dpv="dev prod vite"
alias clearViteCache="rm -rf build/cache/vite"

# Devx aliases
alias dx="devx"
alias cc="devx claude"

# Podman aliases
alias p="podman"
alias pm="podman machine"
alias pms="podman machine start"
alias pmst="podman machine stop"
alias pml="podman machine list"
alias pmr="podman machine restart"
alias pmrm="podman machine rm"
alias pmrmf="podman machine rm --force"

# Important misc aliases
alias c="clear"
alias cr="cursor"

# Less important misc aliases
alias pg="DB_ADAPTER=postgresql"
alias zshrc="cursor ~/.zshrc"
alias gitconfig="cursor ~/.gitconfig"
alias aliases="cursor ~/repos/dotfiles/aliases.zsh"
alias va="less ~/repos/dotfiles/aliases.zsh"

# More arbitrary aliases for specific use cases
alias depst="npm run build && quick deploy dist stickify"
alias tdepst="npm run build && quick deploy dist stickify-test"

# To apply new aliases, run:
# source ~/repos/dotfiles/aliases.zsh
alias re="source ~/repos/dotfiles/aliases.zsh"

# =============================================================================
# Oh-My-Zsh Git Plugin Aliases Reference (plugins=(git))
# These are defined by oh-my-zsh - listed here to avoid naming collisions
# =============================================================================
# g       = git
# ga      = git add
# gaa     = git add --all
# gam     = git am
# gb      = git branch
# gba     = git branch -a
# gbd     = git branch -d
# gbD     = git branch -D
# gbl     = git blame -b -w
# gbr     = git branch --remote
# gbs     = git bisect
# gc      = git commit -v
# gc!     = git commit -v --amend
# gca     = git commit -v -a
# gcam    = git commit -a -m
# gcb     = git checkout -b
# gcd     = git checkout develop
# gcf     = git config --list
# gcl     = git clone --recurse-submodules
# gcm     = git checkout $(git_main_branch)  # NOTE: We use gcmsg for "git commit -m"
# gco     = git checkout
# gcp     = git cherry-pick
# gd      = git diff
# gds     = git diff --staged
# gf      = git fetch
# gfo     = git fetch origin
# gg      = git gui citool
# gl      = git pull  # NOTE: We use glo for "git log"
# glg     = git log --stat
# glog    = git log --oneline --decorate --graph
# gloga   = git log --oneline --decorate --graph --all
# gm      = git merge
# gp      = git push
# gpd     = git push --dry-run
# gpf     = git push --force-with-lease
# gpr     = git pull --rebase
# gpush   = git push origin $(current_branch)
# gr      = git remote
# grb     = git rebase
# grbi    = git rebase -i
# grhh    = git reset --hard
# grs     = git restore
# grss    = git restore --source
# grst    = git restore --staged
# grt     = cd "$(git rev-parse --show-toplevel || echo .)"
# gsh     = git show
# gss     = git status -s
# gst     = git status  # NOTE: We use gst for "git stash push -m"
# gsta    = git stash apply  # NOTE: We use gstap (with index support)
# gstd    = git stash drop  # NOTE: We use gstdrop
# gstl    = git stash list
# gstp    = git stash pop
# gsts    = git stash show --text  # NOTE: We use gstv/gstvp (with index support)
# gsu     = git submodule update
# gsw     = git switch
# gswc    = git switch -c
# gts     = git tag -s
# gunwip  = git log -n 1 | grep -q -c "--wip--" && git reset HEAD~1
# gwip    = git add -A; git rm $(git ls-files --deleted) 2>/dev/null; git commit --no-verify -m "--wip--"
