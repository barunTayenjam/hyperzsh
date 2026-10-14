#!/usr/bin/env zsh

# ─── Detect SSH session ────────────────────────────────────────────────────
IS_SSH=false
[[ -n "$SSH_CONNECTION" ]] && IS_SSH=true

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
  sudo
  history
  fzf
  direnv
  zsh-interactive-cd
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# ─── Autosuggestions config (set before the plugin loads) ──────────────────
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ─── Homebrew/Linuxbrew Zsh completions (before compinit so they register) ─
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

source "$ZSH/oh-my-zsh.sh"

# ─── Zsh completion styles (compinit runs inside oh-my-zsh.sh) ───────────
# Do NOT call compinit here: oh-my-zsh.sh already does it, and zsh-autocomplete
# requires no extra compinit calls.
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ─── Environment Variables ───────────────────────────────────────────────
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/local/sbin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export BAT_THEME="TwoDark"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

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
elif command -v batcat &>/dev/null; then
  alias cat="batcat --style=plain"
fi
export BAT_STYLE="plain"
export BAT_PAGER="less -RF"

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
export FZF_DEFAULT_OPTS="--height 60% --layout=reverse --border --info=inline \
  --color=fg:#cdd6f4,bg:-1,hl:#f38ba8 \
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8 \
  --color=info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc \
  --color=marker:#94e2d5,spinner:#f5e0dc,header:#9399b2"
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
elif command -v fdfind &>/dev/null; then
  # Ubuntu/Debian: fd-find installs as fdfind
  export FZF_DEFAULT_COMMAND="fdfind --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fdfind --type d --hidden --follow --exclude .git"
fi
# Preview only for file search: a global preview breaks Ctrl-R (bat would read stdin)
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
elif command -v batcat &>/dev/null; then
  export FZF_CTRL_T_OPTS="--preview 'batcat --color=always {}'"
fi

# ─── History, Zsh options ───────────────────────────────────────────────
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# ─── Powerlevel10k config (generate this with 'p10k configure') ─────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─── Optional: System info on shell startup (neofetch, local only) ───────
if command -v neofetch &>/dev/null && ! $IS_SSH; then
  neofetch --disable model
fi

# ─── AI command helper  (publishable: NO keys here — reads ~/.secrets at runtime) ─
#   Alt+a   →  AI suggests/completes the command in your buffer (review, then Enter)
#   ai "<text>"  →  prints a suggested command (no widget)
# Backend: $ANTHROPIC_BASE_URL + $ANTHROPIC_AUTH_TOKEN (OpenAI-compatible /chat/completions)
# Override model in ~/.secrets with:  export AI_CLI_MODEL="sonet-4"
_ai_ask() {
  emulate -L zsh
  local req="$1" model="${AI_CLI_MODEL:-sonet-4}" sysp body
  [[ -z "$ANTHROPIC_AUTH_TOKEN" || -z "$ANTHROPIC_BASE_URL" ]] && return 1
  sysp="You are a shell-command generator. Respond with EXACTLY one zsh command and NOTHING else: no reasoning, no markdown, no backticks, no leading \$. The entire response must be the runnable command on a single line."
  body=$(command python3 -c 'import json,sys;print(json.dumps({"model":sys.argv[1],"max_tokens":1024,"messages":[{"role":"system","content":sys.argv[2]},{"role":"user","content":sys.argv[3]}]}))' "$model" "$sysp" "Complete or fix this request: $req") || return 1
  command curl -s -m 35 \
    -H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN" \
    -H "content-type: application/json" \
    "${ANTHROPIC_BASE_URL%/}/chat/completions" \
    -d "$body" 2>/dev/null | command python3 -c '
import sys, json, re
try:
    d = json.load(sys.stdin)          # ignore trailing SSE "data:" garbage
except Exception:
    sys.exit(0)
m = (d.get("choices") or [{}])[0].get("message", {}) or {}
cand = (m.get("content") or "").strip()
fence = re.findall(r"```(?:[a-zA-Z]*)?\s*\n?(.*?)```", cand, re.S)        # fenced block wins
cand = fence[0] if fence else cand
bad = re.compile(r"(thinking|^\s*\d+[.)]|^step|^let|^to |^we |^i |^first|^sure|^here|^of course|^now|^the |^this |^however|^so |^but )", re.I)
lines = [ln.strip().strip("`").strip() for ln in cand.splitlines()]
lines = [ln for ln in lines if ln and not bad.match(ln)]
out = lines[0] if lines else ""        # first command-like line; empty = safe fail
if out.startswith("$ "): out = out[2:]
print(out)
'
}
ai() {
  local c; c=$(_ai_ask "$*") || { print -u2 "AI: credentials missing or request failed."; return 1 }
  [[ -n "$c" ]] && print -r -- "$c" || { print -u2 "AI: no suggestion."; return 1 }
}
_zsh_ai_suggest() {
  emulate -L zsh
  [[ -z "$BUFFER" ]] && { zle -M "AI: type something first, then press Alt+a"; return }
  zle -M "🤖 asking AI (${AI_CLI_MODEL:-sonet-4})..."
  local c; c=$(_ai_ask "$BUFFER")
  if [[ -n "$c" ]]; then
    BUFFER="$c"; CURSOR=${#BUFFER}
    zle -M "🤖 loaded — review, edit, then press Enter (Ctrl+/ to undo)"
  else
    zle -M "AI: no response (check proxy/credentials in ~/.secrets)"
  fi
}
zle -N _zsh_ai_suggest
bindkey '^[a' _zsh_ai_suggest

# Machine-specific extras (PATHs, aliases, secrets) go here — kept out of git
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
