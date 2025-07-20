# Plugin Setup, Troubleshooting & Advanced Notes

This file supplements your main [README](./README.md) with step-by-step instructions, troubleshooting, advanced use, and customization tips for each plugin included in your Oh My Zsh environment.

## Plugin Installation Quick Reference

### 1. git
- Built into Oh My Zsh
- No manual action required.

### 2. zsh-autosuggestions
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
**Troubleshooting:**  
If suggestions don't show, ensure it is listed before zsh-syntax-highlighting and that `$ZSH_CUSTOM/plugins/zsh-autosuggestions` exists.

### 3. zsh-syntax-highlighting
```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
**Note:**  
Always list this as the last plugin to avoid conflicts.

### 4. zsh-interactive-cd
```bash
git clone https://github.com/changyuheng/zsh-interactive-cd.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-interactive-cd
```
**Usage:**  
Use `icd` to get interactive directory navigation in your terminal.

### 5. zsh-autocomplete
```bash
git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
```
**Placement:**  
Always place zsh-autocomplete after zsh-syntax-highlighting in the plugins array for compatibility.

### 6. sudo, history, fzf, direnv
All are included by default in Oh My Zsh or install separately via your system package manager.

---

## General Troubleshooting

**Plugin Not Working?**
- Verify plugin directory exists:
  ```bash
  ls ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins
  ```
- Check `.zshrc`'s `plugins=(...)` list matches your installed plugins.

**Weird Prompt/Colors/Spacing?**
- Ensure you use a Nerd Font (e.g., MesloLGS NF).
- Check font settings in your Terminal emulator.

**Autocomplete or Highlighting Not Working?**
- Reload your configuration:
  ```bash
  source ~/.zshrc
  ```
- Restart your terminal.

**Conflicting Plugins**
- Remove one-by-one to isolate.
- zsh-syntax-highlighting often works best as your last plugin.

---

## Advanced: Custom Plugins

To add a custom plugin:
1. Clone or copy your plugin folder into  
   `~/.oh-my-zsh/custom/plugins/<plugin-name>`
2. List the `<plugin-name>` in your `.zshrc`'s `plugins=(...)`
3. Reload your shell with `source ~/.zshrc`

---

## Updates & Maintenance

To update plugins:
```bash
cd ~/.oh-my-zsh/custom/plugins/<plugin-name>
git pull
```
To update Oh My Zsh itself:
```bash
omz update
```
Check for new CLI tool/plugin versions every few weeks.

---

## Recommended Plugin Use Order (for compatibility)
```text
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting     # Always near/at end
  sudo
  history
  fzf
  direnv
  zsh-interactive-cd
  zsh-autocomplete            # Prefer at the end
)
```

---

## Additional Resources
- [Oh My Zsh Wiki Plugins](https://github.com/ohmyzsh/ohmyzsh/wiki/plugins)
- [Powerlevel10k Theme](https://github.com/romkatv/powerlevel10k)
- [FZF](https://github.com/junegunn/fzf)
- [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [Zsh Autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Zsh Autocomplete](https://github.com/marlonrichert/zsh-autocomplete)
- [Direnv](https://direnv.net/)
- [Eza (ls replacement)](https://github.com/eza-community/eza)

---

Return to the [main README](./README.md) for installation and setup instructions.