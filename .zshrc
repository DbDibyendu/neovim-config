
# Set the ZSH directory
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:/go

# Theme configuration
ZSH_THEME="robbyrussell"

# Enable plugins
plugins=(git zsh-autosuggestions)

# Source Oh My Zsh and NVM
source $ZSH/oh-my-zsh.sh
source ~/.nvm/nvm.sh


# Aliases
alias y-mweb="yarn workspace website dev-mweb"
alias y-web="yarn workspace website dev"
alias yw-dnext='cd packages/website; rm -rf .next; cd ../..;'
alias jestcomp='yarn jest $(pwd)/'
alias y-lr='yarn workspace main dev'
alias yl-dnext='cd packages/main; rm -rf .next; cd ../..;'
alias vz='vim ~/.zshrc'
alias sz='source ~/.zshrc'
alias mp='make sync TEAMS=payments'
alias gpmp='ga .; gcmsg "Make sync"; gp'

# Go environment variables
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"

# Create GOPATH directories if they don't exist
test -d "${GOPATH}" || mkdir -p "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# Source GVM if installed
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"


PATH=~/.console-ninja/.bin:$PATH

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

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
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

source ~/fzf-git.sh/fzf-git.sh

export BINDER_REPO_PATH="/Users/dibyendu.biswas/project/subs-pay/hs-core-widget-binder-query"
