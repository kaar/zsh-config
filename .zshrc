# Path setup
export REPOS="$HOME/Dev/"
export SCRIPTS="$HOME/Dev/scripts"
export BREW_BIN="/opt/homebrew/bin"
export PATH="$BREW_BIN:$SCRIPTS:$PATH"

# Enable vi mode
bindkey -v

# Faster mode switching (no delay after ESC)
export KEYTIMEOUT=1
export EDITOR=nvim

# Enable editing the current command in vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line   # press 'v' in normal mode
bindkey -M viins '^Xe' edit-command-line  # Ctrl+X E in insert mode

# Better navigation in insert mode
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# Undo like vim
bindkey -M viins '^_' undo

# Search history like vim (/ and ?)
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# Fix backspace
bindkey '^?' backward-delete-char

# Optional: make jj act like ESC (faster than reaching ESC)
bindkey -M viins 'jj' vi-cmd-mode

# Colors
autoload -Uz colors && colors

# Prompt
PROMPT='%F{blue}%~%f $ '

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Enable completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-Z}'

# === Aliases ===
source "$ZDOTDIR/alias.zsh"

# === FZF ===
source "$ZDOTDIR/fzf.zsh"
