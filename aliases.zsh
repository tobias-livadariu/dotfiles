# To apply new aliases, run:
# source ~/repos/dotfiles/aliases.zsh

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit"
alias gcm="git commit -m"
alias gdf="git diff"
alias grstr="git restore"
alias grstrs="git restore --staged"
alias gf="git fetch"
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

# Stashing
alias gst="git stash push -m"
alias gsta="git stash apply"
alias gstl="git stash list"
alias gstdrop="git stash drop"
alias gstpop="git stash pop"

# Log viewing
alias gl="git log"
alias glog="git log --oneline --graph --decorate"
alias glast="git log -1 HEAD --stat"

# Git open file functions
# Open nth modified file (zero-indexed, defaults to 0)
gom() {
  local root=$(git rev-parse --show-toplevel)
  local file=$(git diff HEAD --name-only | sed -n "$((${1:-0}+1))p")
  [[ -n "$file" ]] && cursor "$root/$file" || echo "No file at index ${1:-0}"
}

# Open all modified files
goma() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff HEAD --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No modified files"
}

# Open nth staged file (zero-indexed, defaults to 0)
gos() {
  local root=$(git rev-parse --show-toplevel)
  local file=$(git diff --cached --name-only | sed -n "$((${1:-0}+1))p")
  [[ -n "$file" ]] && cursor "$root/$file" || echo "No staged file at index ${1:-0}"
}

# Open all staged files
gosa() {
  local root=$(git rev-parse --show-toplevel)
  local files=(${(f)"$(git diff --cached --name-only)"})
  [[ ${#files[@]} -gt 0 && -n "${files[1]}" ]] && cursor "${files[@]/#/$root/}" || echo "No staged files"
}

# Open nth unstaged file (zero-indexed, defaults to 0)
gou() {
  local root=$(git rev-parse --show-toplevel)
  local file=$(git diff --name-only | sed -n "$((${1:-0}+1))p")
  [[ -n "$file" ]] && cursor "$root/$file" || echo "No unstaged file at index ${1:-0}"
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
alias dcd="dev cd"
alias dcds="dev cd shopify"
dcdr() {
  cd ~/repos/${1:+$1}
}
alias dt="dev test"
alias du="dev up"
alias dd="dev down"
alias ds="dev server"
alias dop="dev open"
alias doa="dev open app"
alias doi="dev open internal"
alias dog="dev open graphiql"

# Devx aliases
alias dx="devx"
alias cc="devx claude"

# Important misc aliases
alias c="clear"
alias cr="cursor"

# Less important misc aliases
alias pg="DB_ADAPTER=postgresql"
alias zshrc="cursor ~/.zshrc"
alias gitconfig="cursor ~/.gitconfig"
alias aliases="cursor ~/repos/dotfiles/aliases.zsh"

# To apply new aliases, run:
# source ~/repos/dotfiles/aliases.zsh