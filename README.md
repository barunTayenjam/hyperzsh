# Ultimate Cross-Platform Zsh Terminal (Production-Ready)

A blazing-fast, developer-centric terminal with Oh My Zsh, Powerlevel10k, Nerd Font, fzf, and the best Zsh plugins—fully compatible across macOS, Ubuntu/Debian, Arch/Manjaro, and WSL2.

## Features
- **Powerlevel10k**: Ultra-fast, beautiful, and customizable prompt.
- **Developer-AI Productivity**: Contextual autocompletion for Git, modern CLI tools, and rich plugin support.
- **Plugins**: git, autosuggestions, syntax highlighting, fzf, direnv, and AI-powered autocomplete.
- Lightning-fast fuzzy search and context-aware autocompletion.
- **Cross-platform**: Clean, tested, and error-free setup on macOS, Linux, WSL2—single config, works everywhere.

## Installation

### 1. Install Zsh and Git
**macOS:**
```bash
brew install zsh git
```
**Ubuntu/Debian/WSL2:**
```bash
sudo apt update
sudo apt install zsh git
```
**Arch/Manjaro:**
```bash
sudo pacman -Syu zsh git
```

### 2. Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 3. Install Powerlevel10k
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### 4. Install Plugins
See [Plugin Setup, Troubleshooting & Advanced Notes](./plugins_setup.md) for details and troubleshooting.

- **zsh-autosuggestions**
  ```bash
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  ```
- **zsh-syntax-highlighting**
  ```bash
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```
- **zsh-interactive-cd**
  ```bash
  git clone https://github.com/changyuheng/zsh-interactive-cd.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-interactive-cd
  ```
- **zsh-autocomplete**
  ```bash
  git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
  ```

### 5. Install Modern CLI Tools
**macOS (Homebrew):**
```bash
brew install fzf direnv eza bat dust duf btm fd neovim neofetch
```
**Ubuntu/Debian/WSL2:**
```bash
sudo apt install fzf direnv exa bat fd-find duf btop neovim neofetch
# Optional: Install 'eza', 'dust' via cargo (Rust) if not in repo
```
**Arch/Manjaro:**
```bash
sudo pacman -S fzf direnv eza bat dust duf bottom fd neovim neofetch
```

### 6. Install Nerd Font (MesloLGS)
**macOS (Homebrew):**
```bash
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font
```
Set "MesloLGS NF" as your terminal font in Preferences.

**Linux/WSL2:**
- Download from [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
- Unzip and copy `.ttf` files to `~/.local/share/fonts/`
- Run `fc-cache -fv`
- Set terminal font to "MesloLGS NF" in terminal emulator preferences.

**Arch Linux:**
```bash
sudo pacman -S nerd-fonts-meslo
```
Or use your AUR helper.

**Windows (WSL2):**
- Download the zip from [Nerd Fonts](https://www.nerdfonts.com/font-downloads)
- Install all `.ttf` files.
- Set your Windows Terminal Profile to "MesloLGS NF".

### 7. Configure your Terminal
- Copy `.zshrc` from this repo to your `$HOME` directory.
- Optionally copy `.p10k.zsh.example` to `~/.p10k.zsh`, and run `p10k configure`.

Source your shell:
```bash
source ~/.zshrc
```
Optionally, run Powerlevel10k's setup wizard:
```bash
p10k configure
```

## Tips & Troubleshooting
- Update plugins: Pull new commits from plugin repositories regularly.
- For unknown commands/tools: Install with your package manager or from the official repo.
- WSL users: All *nix instructions apply; set fonts via Windows Terminal settings.

See [Plugin Setup, Troubleshooting & Advanced Notes](./plugins_setup.md) for plugin-specific help.

## License
MIT.

Credit: Community plugin developers and Powerlevel10k contributors.