
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


fp() {
  local dir
  dir=$(find ~/project -mindepth 1 -maxdepth 2 -type d | fzf)
  if [[ -n "$dir" ]]; then
    cd "$dir" || echo "Failed to change directory"
  else
    echo "No directory selected"
  fi
}
