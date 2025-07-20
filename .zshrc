#!/usr/bin/env zsh

# ─── Powerlevel10k Instant Prompt (top, for fast prompt load) ──────────────
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─── Oh My Zsh and Plugins ────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  sudo
  history
  fzf
  direnv
  zsh-interactive-cd
  zsh-autocomplete
)
source "$ZSH/oh-my-zsh.sh"

# ─── Zsh Native Completion/Completions Bootstrapping ─────────────────────
autoload -Uz compinit
compinit
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
if command -v eza &>/dev/null; then
  alias ls="eza --group-directories-first --icons --git"
  alias ll="eza --long --header --git --icons --all"
  alias lt="eza --tree --level=2 --icons"
  alias lta="eza --tree --level=2 --icons --all"
else
  alias ls="ls --color=auto"
  alias ll="ls -la"
fi

if command -v bat &>/dev/null; then
  alias cat="bat --style=plain"
  export BAT_STYLE="plain"
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

alias gs="git status --short --branch"
alias gd="git diff"
alias gc="git commit"
alias gp="git push"
alias gl="git log --graph --pretty=format:'%C(yellow)%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"

# ─── FZF: Fuzzy Finder config ────────────────────────────────────────────
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ─── History, Zsh options ───────────────────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# ─── Powerlevel10k config (generate this with 'p10k configure') ─────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─── Optional: System info on shell startup (neofetch) ──────────────────
if command -v neofetch &>/dev/null; then
  neofetch --disable model
fi

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
