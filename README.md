# Dotfile configuration

## Pre-requisites

### Install [Homebrew](https://brew.sh/) as package manager

You can download all the cli tools from here https://www.josean.com/posts/7-amazing-cli-tools

### Stow

Download `Stow` to get symlink the dotfiles to $HOME.

```
brew install stow
```

Next stow in the repo via

```
stow -t ~ .
```

## Neovim Setup

If you clone the repo into your machine and use the config by copying .config/nvim to your home folder, wait for the plugins, language servers and parsers to install with lazy.nvim, Mason and nvim-treesitter. If you are opening a lua file or another file I have language servers configured for, like html, css or javascript/typescript, you might also get an error saying that the server failed to start. This is because Mason hasn't installed it yet. Press enter to continue, Mason will automatically install it.

### Setup Requires

- True Color Terminal Like: [iTerm2](https://iterm2.com/)
- [Neovim](https://neovim.io/) (Version 0.9 or Later)
- [Nerd Font](https://www.nerdfonts.com/) - I use Meslo Nerd Font
- [Ripgrep](https://github.com/BurntSushi/ripgrep) - For Telescope Fuzzy Finder
- XCode Command Line Tools
- If working with typescript/javascript and the typescript language server like me. You might need to install node/npm.

If you're on mac, like me, you can install iTerm2, Neovim, Meslo Nerd Font, Ripgrep and Node with homebrew.

iTerm2:

```bash
brew install --cask iterm2
```

Nerd font:

```bash
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
```

Neovim:

```bash
brew install neovim
```

Ripgrep:

```bash
brew install ripgrep
```

Node/Npm:

```bash
brew install node
```

For XCode Command Line Tools do:

```bash
xcode-select --install
```

## tmux config

✍🏼 Blog Post: [How To Use and Configure Tmux Alongside Neovim](https://josean.com/posts/tmux-setup)

📹 Youtube Guide: [How I Setup And Use Tmux Alongside Neovim for an Awesome Dev Workflow](https://youtu.be/U-omALWIBos)

## zshrc config

## Useful Links

Josean Dev Repo: https://github.com/josean-dev/dev-environment-files?tab=readme-ov-file
Netwr Shortcuts: https://gist.github.com/danidiaz/37a69305e2ed3319bfff9631175c5d0f

## General Tips

Save without formatter in vim

```
:noautocmd w
```

For Binders Tests, You have to cd into the particular domain
for example for subscriptions

```
cd domains/subscriptions
```

then

```
go mod tidy
```

And then u can test via <leader> zg (which starts dlv-go)
