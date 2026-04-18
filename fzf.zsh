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
GRUVBOX_MATERIAL='
  --color=bg+:#3a3735,bg:#2a2827,spinner:#ea6962,hl:#928374
  --color=fg:#d4be98,header:#928374,info:#89b482,pointer:#ea6962
  --color=marker:#ea6962,fg+:#d4be98,prompt:#ea6962,hl+:#ea6962
  --color=border:#504945'
FZF_COLOR_SCHEMA=$GRUVEBOX_MATERIAL
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='❯ '
  --pointer='▶'
  --marker='✓'
  $FZF_COLOR_SCHEMA
  --bind='ctrl-d:half-page-down,ctrl-u:half-page-up'
"

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

# fzf opens in a tmux split-pane
export FZF_TMUX=1

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
