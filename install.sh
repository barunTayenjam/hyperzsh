#!/usr/bin/env zsh
# HyperZshrc installer — safe to re-run, non-destructive.
# Usage: curl -fsSL https://raw.githubusercontent.com/barunTayenjam/hyperzshrc/main/install.sh | zsh
set -e

REPO_RAW="https://raw.githubusercontent.com/barunTayenjam/hyperzshrc/main"
OMZ_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$OMZ_DIR/custom}"

say()  { print -P "%F{cyan}[hyperzshrc]%f $1" }
ok()   { say "%F{green}✓%f $1" }
warn() { say "%F{yellow}!%f $1" }
fail() { say "%F{red}✗%f $1" >&2; exit 1 }

# ─── Platform + package manager ────────────────────────────────────────────
OS="$(uname -s)"
PM=none
case "$OS" in
  Darwin) (( $+commands[brew] )) && PM=brew ;;
  Linux)
    if   (( $+commands[apt-get] )); then PM=apt
    elif (( $+commands[pacman]  )); then PM=pacman
    fi ;;
esac

SUDO=""
_SUDO_OK=""
ensure_sudo() {
  [[ -n $_SUDO_OK ]] && return 0
  (( EUID == 0 )) && { _SUDO_OK=1; return 0 }
  if sudo -n true 2>/dev/null; then SUDO="sudo"; _SUDO_OK=1; return 0; fi
  if sudo -v 2>/dev/null; then SUDO="sudo"; _SUDO_OK=1; return 0; fi
  return 1
}

# ─── 1. zsh + git (hard requirement) ───────────────────────────────────────
if ! (( $+commands[zsh] )) || ! (( $+commands[git] )); then
  [[ $PM == none ]] && fail "zsh/git missing and no package manager found — install them first"
  say "installing zsh + git via $PM..."
  case "$PM" in
    apt)    ensure_sudo || fail "sudo required to install zsh/git"
            $SUDO apt-get update -qq
            $SUDO apt-get install -y zsh git || fail "could not install zsh/git" ;;
    pacman) ensure_sudo || fail "sudo required to install zsh/git"
            $SUDO pacman -Sy --noconfirm
            $SUDO pacman -S --noconfirm --needed zsh git || fail "could not install zsh/git" ;;
    brew)   brew install zsh git || fail "could not install zsh/git" ;;
  esac
  ok "zsh + git ready"
fi

# ─── 2. Modern CLI tools (best-effort — all aliases are guarded) ───────────
install_tools() {
  local -a pkgs
  case "$PM" in
    apt|pacman) ensure_sudo || { warn "no sudo — skipping system tools"; return 0 } ;;
  esac
  case "$PM" in
    brew)
      local t
      for t in fzf direnv eza bat dust duf bottom fd neovim; do
        (( $+commands[$t] )) || pkgs+=("$t")
      done
      (( ${#pkgs} )) && brew install "${pkgs[@]}" && ok "tools: ${pkgs[*]}"
      ;;
    apt)
      (( $+commands[fzf]    )) || pkgs+=(fzf)
      (( $+commands[direnv] )) || pkgs+=(direnv)
      (( $+commands[bat] || $+commands[batcat] )) || pkgs+=(bat)
      (( $+commands[fd] || $+commands[fdfind]  )) || pkgs+=(fd-find)
      (( $+commands[duf]    )) || pkgs+=(duf)
      (( $+commands[btop]   )) || pkgs+=(btop)
      (( $+commands[nvim]   )) || pkgs+=(neovim)
      (( ${#pkgs} )) && $SUDO apt-get install -y "${pkgs[@]}" && ok "tools: ${pkgs[*]}"
      ;;
    pacman)
      local -a want=(fzf direnv eza bat dust duf bottom fd neovim)
      local t
      for t in "${want[@]}"; do
        case "$t" in
          fd) (( $+commands[fd] || $+commands[fdfind] )) || pkgs+=(fd) ;;
          bottom) (( $+commands[btm] )) || pkgs+=(bottom) ;;
          *) (( $+commands[$t] )) || pkgs+=("$t") ;;
        esac
      done
      (( ${#pkgs} )) && $SUDO pacman -S --noconfirm --needed "${pkgs[@]}" && ok "tools: ${pkgs[*]}"
      ;;
    *) warn "no package manager — install tools manually (see README)" ;;
  esac
  return 0
}
install_tools

# ─── 3. Oh My Zsh ──────────────────────────────────────────────────────────
if [[ -d $OMZ_DIR ]]; then
  ok "oh-my-zsh already installed"
else
  say "installing oh-my-zsh..."
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ok "oh-my-zsh installed"
fi

# ─── 4. Powerlevel10k theme ────────────────────────────────────────────────
if [[ -d $ZSH_CUSTOM/themes/powerlevel10k ]]; then
  ok "powerlevel10k already installed"
else
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k" \
    && ok "powerlevel10k installed" \
    || warn "powerlevel10k clone failed — re-run this installer to retry"
fi

# ─── 5. Plugins ────────────────────────────────────────────────────────────
install_plugin() {
  local name=$1 url=$2
  if [[ -d $ZSH_CUSTOM/plugins/$name ]]; then
    ok "$name already installed"
  else
    git clone --depth=1 "$url" "$ZSH_CUSTOM/plugins/$name" \
      && ok "$name installed" \
      || warn "$name install failed — re-run this installer to retry"
  fi
}
install_plugin zsh-autosuggestions \
  https://github.com/zsh-users/zsh-autosuggestions
install_plugin zsh-syntax-highlighting \
  https://github.com/zsh-users/zsh-syntax-highlighting
install_plugin zsh-interactive-cd \
  https://github.com/changyuheng/zsh-interactive-cd
install_plugin zsh-autocomplete \
  https://github.com/marlonrichert/zsh-autocomplete

# ─── 6. ~/.zshrc (backup existing, skip if already current) ────────────────
tmp=$(mktemp)
curl -fsSL "$REPO_RAW/.zshrc" -o "$tmp" || fail "could not download .zshrc (network?)"
if [[ -f $HOME/.zshrc ]] && cmp -s "$tmp" "$HOME/.zshrc"; then
  ok "~/.zshrc already up to date"
else
  if [[ -f $HOME/.zshrc ]]; then
    bak="$HOME/.zshrc.backup.$(date +'%Y%m%d%H%M%S')"
    cp "$HOME/.zshrc" "$bak"
    ok "backed up existing ~/.zshrc → $bak"
  fi
  cp "$tmp" "$HOME/.zshrc"
  ok "~/.zshrc installed"
fi
rm -f "$tmp"

# ─── 7. Machine-local overrides + p10k config seed ─────────────────────────
if [[ ! -f $HOME/.zshrc.local ]]; then
  cat > "$HOME/.zshrc.local" <<'EOF'
# ~/.zshrc.local — machine-specific config, sourced last by ~/.zshrc (kept out of git)
EOF
  ok "created ~/.zshrc.local"
fi

if [[ ! -f $HOME/.p10k.zsh ]]; then
  seed="$ZSH_CUSTOM/themes/powerlevel10k/config/p10k-classic.zsh"
  [[ -f $seed ]] && cp "$seed" "$HOME/.p10k.zsh" && ok "seeded ~/.p10k.zsh (classic) — run 'p10k configure' to restyle"
fi

# ─── 8. Summary ────────────────────────────────────────────────────────────
print ""
ok "%BDone.%b Next steps:"
print "  1. Set a Nerd Font in your terminal (e.g. MesloLGS NF): https://www.nerdfonts.com/font-downloads"
print "  2. exec zsh        — start your new shell"
print "  3. p10k configure  — walk through the prompt wizard (optional)"
if [[ ${SHELL:t} != zsh ]]; then
  print "  4. chsh -s \$(command -v zsh)  — make zsh your login shell"
fi
