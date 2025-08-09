#!/usr/bin/env zsh

# ─── Powerlevel10k Instant Prompt (top, for fast prompt load) ──────────────
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh and Plugins ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
# For a list of plugins, see: https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# Follow plugin best practices for order:
# 1. Built-in plugins (git, sudo, etc.)
# 2. Other plugins
# 3. zsh-autosuggestions
# 4. zsh-syntax-highlighting (must be near the end)
# 5. zsh-autocomplete (must be last)
plugins=(
  git
  sudo
  history
  fzf
  direnv
  zsh-interactive-cd
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-autocomplete
)
source "$ZSH/oh-my-zsh.sh"

# ─── Zsh Native Completion System Configuration ──────────────────────────
# Oh My Zsh runs compinit for us, so we only need to configure it.
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ─── Homebrew/Linuxbrew Zsh completions (optional, cross-platform) ──────
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# ─── Environment Variables ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="TwoDark"

# ─── Modern CLI Tools & Aliases ─────────────────────────────────────────
# For modern replacements for common commands
if command -v eza &>/dev/null; then
  alias ls="eza --group-directories-first --icons --git"
  alias ll="eza --long --header --git --icons --all"
  alias lt="eza --tree --level=2 --icons"
  alias lta="eza --tree --level=2 --icons --all"
else
  # Use -G on macOS for color, --color=auto on GNU
  if [[ "$(uname)" == "Darwin" ]]; then
    alias ls="ls -G"
  else
    alias ls="ls --color=auto"
  fi
  alias ll="ls -la"
fi

if command -v bat &>/dev/null; then
  # Use 'batcat' on Debian/Ubuntu if 'bat' is not available
  alias cat="bat --style=plain --paging=never"
  export BAT_PAGER="less -RF"
fi

if command -v dust &>/dev/null; then
  alias du="dust"
fi

if command -v duf &>/dev/null; then
  alias df="duf"
fi

if command -v btm &>/dev/null; then
  alias top="btm"
fi

# Git Aliases
alias gs="git status --short --branch"
alias gd="git diff"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias ga="git add"

# ─── FZF: Fuzzy Finder config ────────────────────────────────────────────
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
  # FZF settings
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}' --preview-window=right:50%:wrap"
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ─── History, Zsh options ───────────────────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS      # Don't store duplicate commands
setopt HIST_FIND_NO_DUPS       # Don't show duplicates when searching
setopt HIST_REDUCE_BLANKS      # Remove blank lines from history
setopt INC_APPEND_HISTORY      # Add commands to history immediately
setopt EXTENDED_HISTORY        # Save timestamp of command
setopt SHARE_HISTORY           # Share history between all sessions

# ─── Powerlevel10k config (This file is version-controlled) ─────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─── Optional: System info on shell startup (neofetch) ──────────────────
# Uncomment the following lines to show system info when starting a new shell.
# if command -v neofetch &>/dev/null; then
#   neofetch --disable model
# fi

# ─── Local/Private user config ──────────────────────────────────────────
# For any local settings that shouldn't be in git, create ~/.zshrc.local
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
