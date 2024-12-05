# Dotfile configuration

## Pre-requisites 


## Neovim Setup

If you clone the repo into your machine and use the config by copying .config/nvim to your home folder, wait for the plugins, language servers and parsers to install with lazy.nvim, Mason and nvim-treesitter. If you are opening a lua file or another file I have language servers configured for, like html, css or javascript/typescript, you might also get an error saying that the server failed to start. This is because Mason hasn't installed it yet. Press enter to continue, Mason will automatically install it.

Relevant Files
.config/nvim
Setup Requires
True Color Terminal Like: iTerm2
Neovim (Version 0.9 or Later)
Nerd Font - I use Meslo Nerd Font
Ripgrep - For Telescope Fuzzy Finder
XCode Command Line Tools
If working with typescript/javascript and the typescript language server like me. You might need to install node/npm.
If you're on mac, like me, you can install iTerm2, Neovim, Meslo Nerd Font, Ripgrep and Node with homebrew.

iTerm2:

brew install --cask iterm2
Nerd font:

brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
Neovim:

brew install neovim
Ripgrep:

brew install ripgrep
Node/Npm:

brew install node
For XCode Command Line Tools do:

xcode-select --install


## tmux config

✍🏼 Blog Post: How To Use and Configure Tmux Alongside Neovim

📹 Youtube Guide: How I Setup And Use Tmux Alongside Neovim for an Awesome Dev Workflow


## zshrc config


## Useful Links

Josean Dev Repo: https://github.com/josean-dev/dev-environment-files?tab=readme-ov-file
