# Powerlevel10k Configuration (https://github.com/romkatv/powerlevel10k)
# Generated with 'p10k configure' or created manually for a default setup.

# --------------------[ General ]--------------------
# Zsh theme.
POWERLEVEL9K_MODE='nerdfont-complete'

# --------------------[ Prompt Structure ]--------------------
# The elements that make up the prompt.
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  os_icon               # OS icon
  dir                   # current directory
  vcs                   # git status
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                # exit code of the last command
  command_execution_time # duration of the last command
  time                  # current time
)

# --------------------[ Styling & Colors ]--------------------
# Directory styling
POWERLEVEL9K_DIR_STYLE='blue'
POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_DIR_ANCHOR_BOLD=true

# Git status styling
POWERLEVEL9K_VCS_CLEAN_FOREGROUND='green'
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='yellow'
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='cyan'

# Command execution time styling
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='yellow'

# Status styling
POWERLEVEL9K_STATUS_OK_FOREGROUND='green'
POWERLEVEL9K_STATUS_ERROR_FOREGROUND='red'

# --------------------[ Icons ]--------------------
# Use Nerd Font icons for different OSes.
POWERLEVEL9K_OS_ICON_FOREGROUND='white'

# --------------------[ Transient Prompt ]--------------------
# Makes the prompt appear on a new line.
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=true

# --------------------[ Instant Prompt ]--------------------
# Speeds up shell startup.
POWERLEVEL9K_INSTANT_PROMPT=quiet

# To customize Powerlevel10k, run `p10k configure` or edit this file.
# For more details, see the Powerlevel10k documentation.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
