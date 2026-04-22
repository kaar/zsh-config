# Path setup
export GITHUB_REPOS="$HOME/GitHub"
export DEV="$HOME/Dev"
export REPOS=$GITHUB_REPOS

export SCRIPTS="$HOME/Dev/scripts"
export PATH="${HOMEBREW_PREFIX}/bin:$SCRIPTS:$PATH"
FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

export EDITOR=nvim
export MANPAGER="nvim +Man!"

bindkey -v
export KEYTIMEOUT=1

# Edit command line in $EDITOR
# - v        (command mode)  standard zsh vi-mode binding
# - Ctrl-X Ctrl-E (insert)   standard readline binding (same as bash)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v       edit-command-line
bindkey -M viins '^X^E'  edit-command-line

# - Ctrl-A   jump to beginning of line
# - Ctrl-E   jump to end of line
# - Ctrl-_   undo
# - Ctrl-?   backspace (fixes terminals that send DEL)
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^_' undo
bindkey '^?' backward-delete-char

# Vim-style history search in command mode
# - /        incremental search backward
# - ?        incremental search forward
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

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

source "$ZDOTDIR/alias.zsh"
source "$ZDOTDIR/fzf.zsh"
