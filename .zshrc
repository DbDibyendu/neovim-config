# Set the ZSH directory
export ZSH="$HOME/.oh-my-zsh"

# Update PATH
export PATH=$PATH:/go:${HOME}/go/bin

# Theme configuration
ZSH_THEME="robbyrussell"

# Enable plugins
plugins=(git zsh-autosuggestions)

# Source Oh My Zsh and NVM
source $ZSH/oh-my-zsh.sh

# Aliases
alias y-mweb="yarn workspace website dev-mweb"
alias y-web="yarn workspace website dev"
alias yw-dnext='cd packages/website; rm -rf .next; cd ../..;'
alias y-lr='yarn workspace main dev'
alias yl-dnext='cd packages/main; rm -rf .next; cd ../..;'

# Source GVM if installed, go version manager
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# ---- FZF -----
# fuzzy finder for projects directory
fp() {
  local dir
  dir=$(find ~/project -mindepth 1 -maxdepth 2 -type d | fzf)
  if [[ -n "$dir" ]]; then
    cd "$dir" || echo "Failed to change directory"
  else
    echo "No directory selected"
  fi
}
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd for path candidates
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"


# Binder repo path
export BINDER_REPO_PATH="/Users/dibyendu.biswas/project/subs-pay/hs-core-widget-binder-query"


# Go environment variables
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Append GOPATH and GOBIN to PATH
export PATH="${PATH}:${GOPATH}/bin"
