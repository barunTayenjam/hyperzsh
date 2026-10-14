<div align="center">

# ⚡ HyperZshrc

**A blazing-fast, developer-centric Zsh setup — one `.zshrc` that works everywhere.**

[![Zsh](https://img.shields.io/badge/zsh-5.8%2B-4EBAFF?logo=zsh&logoColor=white)](https://www.zsh.org/)
[![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Ubuntu%20%7C%20Arch%20%7C%20WSL2-lightgrey)](#-installation)
[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

Oh My Zsh · Powerlevel10k · fzf · zsh-autocomplete · **built-in AI command helper**

</div>

---

## ✨ What's inside

| | |
|---|---|
| 🚀 **Turbo prompt** | Powerlevel10k with instant prompt — shell feels instant |
| 🧠 **Smart completion** | zsh-autocomplete type-ahead + autosuggestions + syntax highlighting |
| 🎯 **Fuzzy everything** | fzf with Catppuccin colors: files (Ctrl-T), dirs (Alt-C), history (Ctrl-R) |
| 🤖 **AI command helper** | Press <kbd>Alt+a</kbd> — AI completes your command line. No keys in this repo |
| 🛠 **Modern tools, aliased** | `eza` `bat` `dust` `duf` `bottom` `fd` — with graceful fallbacks (Ubuntu's `batcat`/`fdfind` handled) |
| 🌍 **Cross-platform** | Same config on macOS, Ubuntu/Debian, Arch/Manjaro, WSL2 |
| 🔒 **SSH-aware** | No banner spam on remote sessions |
| 🧩 **Machine overrides** | Personal bits live in `~/.zshrc.local` — never in git |

## ⌨️ Shortcuts

| Key / command | What it does |
|---|---|
| <kbd>Alt</kbd>+<kbd>a</kbd> | AI completes the current command line (review, then Enter) |
| `ai "list docker containers"` | Print an AI-suggested command |
| <kbd>Ctrl</kbd>+<kbd>T</kbd> | Fuzzy-find files with preview |
| <kbd>Alt</kbd>+<kbd>C</kbd> | Fuzzy-jump into a directory |
| <kbd>Ctrl</kbd>+<kbd>R</kbd> | Fuzzy history search |
| <kbd>Tab</kbd> | Type-ahead completion menu |
| `cd **` + <kbd>Tab</kbd> | Interactive directory navigation |
| `gs` `gd` `gc` `gp` `gl` | git status / diff / commit / push / log |
| `ll` `lt` `lta` | ls long / tree / tree-all (via eza) |

## 🚀 Installation

**One command:**

```bash
curl -fsSL https://raw.githubusercontent.com/barunTayenjam/hyperzshrc/main/install.sh | zsh
```

Idempotent & non-destructive — re-run anytime. Installs Oh My Zsh, Powerlevel10k, all plugins, and system tools it can (via brew/apt/pacman), backs up your existing `~/.zshrc`, then points you at the 3 finishing steps (font, `exec zsh`, `p10k configure`).

<details>
<summary>Manual step-by-step install</summary>

### 1. Prerequisites

```bash
# macOS
brew install zsh git

# Ubuntu / Debian / WSL2
sudo apt update && sudo apt install zsh git

# Arch / Manjaro
sudo pacman -Syu zsh git
```

### 2. Oh My Zsh + Powerlevel10k

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 3. Plugins

```bash
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

git clone https://github.com/zsh-users/zsh-autosuggestions     $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone https://github.com/changyuheng/zsh-interactive-cd    $ZSH_CUSTOM/plugins/zsh-interactive-cd
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete $ZSH_CUSTOM/plugins/zsh-autocomplete
```

Details & troubleshooting → [plugins_setup.md](plugins_setup.md)

### 4. Modern CLI tools

```bash
# macOS
brew install fzf direnv eza bat dust duf btm fd neovim

# Ubuntu / Debian / WSL2  (bat→batcat, fd→fdfind — handled automatically)
sudo apt install fzf direnv bat fd-find duf btop neovim
cargo install eza dust   # if not in your repos

# Arch / Manjaro
sudo pacman -S fzf direnv eza bat dust duf bottom fd neovim
```

### 5. Nerd Font (required for prompt icons)

```bash
# macOS
brew install --cask font-meslo-lg-nerd-font

# Arch / Manjaro
sudo pacman -S nerd-fonts-meslo
```

Linux/WSL2: grab [MesloLGS NF](https://www.nerdfonts.com/font-downloads), drop the `.ttf`s in `~/.local/share/fonts/`, run `fc-cache -fv`, and select the font in your terminal.

### 6. Grab the config

```bash
# backup, install, reload
cp ~/.zshrc ~/.zshrc.backup.$(date +'%Y%m%d%H%M%S')
curl -o ~/.zshrc https://raw.githubusercontent.com/barunTayenjam/hyperzshrc/main/.zshrc
source ~/.zshrc
```

### 7. First-run polish

```bash
p10k configure   # walk through the prompt wizard (re-run anytime)
exec zsh         # fresh shell, instant prompt kicks in
```

</details>

## 🤖 AI command helper

Works out of the box if your environment already provides an OpenAI-compatible backend:

```bash
# put credentials in ~/.secrets (never in git)
export ANTHROPIC_BASE_URL="https://your-endpoint/v1"
export ANTHROPIC_AUTH_TOKEN="sk-..."
export AI_CLI_MODEL="sonet-4"          # optional override
```

- <kbd>Alt</kbd>+<kbd>a</kbd> → replaces your buffer with one suggested command (review before running!)
- `ai "..."` → prints the suggestion

**No keys live in this repository** — the helper reads `~/.secrets` at runtime only.

## ⚙️ Configuration & overrides

| File | Role |
|---|---|
| [`.zshrc`](.zshrc) | The whole setup — versioned here |
| `~/.zshrc.local` | Your machine-specific PATHs, aliases, secrets — sourced last, not in git |
| `~/.p10k.zsh` | Prompt style — generate with `p10k configure` |
| [`plugins_setup.md`](plugins_setup.md) | Per-plugin details & troubleshooting |

## 🔧 Troubleshooting

- **Prompt icons broken?** → Nerd Font not active — check your terminal font settings.
- **Plugin not loading?** → `ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins` and match it against `plugins=(...)`.
- **Completion feels off?** → never add your own `compinit` call — `oh-my-zsh.sh` handles it (zsh-autocomplete requirement).
- **Update everything:** `omz update`, then `git -C ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/<name> pull`.

More: [plugins_setup.md](plugins_setup.md)

## 📄 License

[MIT](LICENSE) — credit to [Powerlevel10k](https://github.com/romkatv/powerlevel10k), [Oh My Zsh](https://ohmyz.sh/), and the plugin authors.
