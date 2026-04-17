# === FZF ===
# ┌──────────┬──────────────────────────────────────────────────────────────┐
# │ Shortcut │ What it does                                                 │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ Ctrl+R   │ Fuzzy search command history (Ctrl+Y copies to clipboard)    │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ Ctrl+T   │ Fuzzy find files, insert path at cursor (bat preview)        │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ Alt+C    │ Fuzzy cd into subdirectories (eza tree preview)              │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ fcd      │ Fuzzy cd into any directory under ~/Dev                      │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ fe       │ Fuzzy find a file & open in nvim                             │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ fkill    │ Fuzzy select & kill processes                                │
# ├──────────┼──────────────────────────────────────────────────────────────┤
# │ frg      │ Ripgrep search → fzf → open result in nvim at the exact line │
# └──────────┴──────────────────────────────────────────────────────────────┘

# Load fzf keybindings and completion
eval "$(fzf --zsh)"

# Use fd for faster, git-aware file finding
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Default fzf appearance
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt="❯ "
  --pointer="▶"
  --marker="✓"
  --color=fg:#c0caf5,bg:-1,hl:#bb9af7
  --color=fg+:#c0caf5,bg+:#283457,hl+:#7dcfff
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#bb9af7
  --color=marker:#9ece6a,spinner:#bb9af7,header:#565f89
  --bind="ctrl-d:half-page-down,ctrl-u:half-page-up"
'

# Ctrl+T: file finder with bat preview
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:200 {} 2>/dev/null || eza --icons --tree --level=2 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

# Alt+C: directory finder with eza tree preview
export FZF_ALT_C_OPTS="
  --preview 'eza --icons --tree --level=2 --color=always {}'
"

# Ctrl+R: history search with preview of full command
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window 'up:3:wrap'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'ctrl-y: copy to clipboard'
"

# fcd: fuzzy cd into any directory under ~/Dev
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git . "$REPOS" | fzf --preview 'eza --icons --tree --level=2 --color=always {}')
  [[ -n "$dir" ]] && cd "$dir"
}

# fe: fuzzy find & edit in nvim
fe() {
  local file
  file=$(fzf --preview 'bat --color=always --style=numbers --line-range=:200 {}')
  [[ -n "$file" ]] && nvim "$file"
}

# fkill: fuzzy kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf --multi --header='Select process(es) to kill' | awk '{print $2}')
  [[ -n "$pid" ]] && echo "$pid" | xargs kill -${1:-9}
}

# frg: ripgrep + fzf — search file contents, then open in nvim at the line
frg() {
  local result
  result=$(
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --delimiter ':' \
        --preview 'bat --color=always --highlight-line {2} {1}' \
        --preview-window 'up:60%:+{2}-5'
  )
  [[ -n "$result" ]] && nvim "$(echo "$result" | cut -d: -f1)" +"$(echo "$result" | cut -d: -f2)"
}
