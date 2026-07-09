# =============================================================================
# .zshrc — Feature-rich Zsh configuration
# Managed by Ansible — edit at: dots/.zshrc
# =============================================================================
# Supports: macOS (Homebrew) + Linux (apt / manual installs)
# Theme:    Catppuccin Mocha (FZF) + Rosé Pine (Starship prompt)
# Features: fzf completions, syntax highlighting, autosuggestions, zoxide, eza
# =============================================================================

# ---- OS Detection -----------------------------------------------------------
export ZSH_OS="$(uname -s)"   # Darwin | Linux

# ---- Performance: only run compinit once per day ---------------------------
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"
else
  compinit -C -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# ---- History ----------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS        # No consecutive duplicates
setopt HIST_IGNORE_SPACE       # Commands prefixed with space are not saved
setopt HIST_REDUCE_BLANKS      # Remove extra blanks from history
setopt SHARE_HISTORY           # Share history across all sessions
setopt APPEND_HISTORY          # Append rather than overwrite history file
setopt EXTENDED_HISTORY        # Record timestamp in history
setopt INC_APPEND_HISTORY      # Write to history file immediately

# ---- Path -------------------------------------------------------------------
typeset -U path                # Ensure unique entries in $PATH

# macOS Homebrew (Apple Silicon)
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
# macOS Homebrew (Intel)
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# User-local binaries (zoxide, cargo, pipx, etc.)
path=("$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin" $path)

# ---- Completion styling -----------------------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format '%F{#cba6f7}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{#f38ba8}No matches for: %d%f'
zstyle ':completion:*:messages' format '%F{#a6e3a1}%d%f'
zstyle ':completion:*:corrections' format '%F{#fab387}%d (errors: %e)%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' rehash true

# ---- Zsh options ------------------------------------------------------------
setopt AUTO_CD                 # cd by just typing the directory name
setopt AUTO_PUSHD              # Push directories onto the stack
setopt PUSHD_IGNORE_DUPS       # No duplicate dirs in stack
setopt CORRECT                 # Correct spelling of commands
setopt NO_BEEP                 # Silence please

# ---- Keybindings ------------------------------------------------------------
bindkey -e                     # Emacs-style line editing (default for most)
bindkey '^[[A' history-search-backward   # Up arrow → search history
bindkey '^[[B' history-search-forward    # Down arrow → search history
bindkey '^[^[[C' forward-word            # Alt+Right → forward word
bindkey '^[^[[D' backward-word           # Alt+Left → backward word
bindkey '^[[H' beginning-of-line         # Home
bindkey '^[[F' end-of-line               # End

# ---- FZF --------------------------------------------------------------------
# Catppuccin Mocha color palette for fzf
export FZF_DEFAULT_OPTS="
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a
  --height=50%
  --layout=reverse
  --border=rounded
  --border-label=' fzf '
  --border-label-pos=3
  --prompt='  '
  --pointer=' '
  --marker=' '
  --info=right
  --separator='─'
  --scrollbar='│'
"

# Use fd for fzf file finding (respects .gitignore, faster)
# Ubuntu installs fd as fdfind
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
elif command -v fdfind &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
fi

# fzf file preview with bat
if command -v bat &>/dev/null; then
  export FZF_CTRL_T_OPTS="
    --preview 'bat --color=always --style=numbers,changes --line-range=:300 {}'
    --preview-window 'right:55%:border-rounded'
    --bind 'ctrl-/:change-preview-window(down|hidden|)'
  "
fi

# fzf directory preview with eza/tree
if command -v eza &>/dev/null; then
  export FZF_ALT_C_OPTS="
    --preview 'eza --tree --color=always --icons --level=2 {}'
    --preview-window 'right:45%:border-rounded'
  "
elif command -v tree &>/dev/null; then
  export FZF_ALT_C_OPTS="--preview 'tree -C -L 2 {}' --preview-window 'right:45%:border-rounded'"
fi

# fzf history search enhancements
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'CTRL-Y: copy  CTRL-/: toggle preview'
"

# Source fzf shell integrations (key bindings + completions)
if [[ "$ZSH_OS" == "Darwin" ]]; then
  # Homebrew fzf
  if [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
  fi
  if [[ -f "$(brew --prefix)/opt/fzf/shell/completion.zsh" ]]; then
    source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  fi
elif [[ "$ZSH_OS" == "Linux" ]]; then
  # apt fzf puts bindings here; fallback to ~/.fzf.zsh (git install)
  if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [[ -f "$HOME/.fzf.zsh" ]]; then
    source "$HOME/.fzf.zsh"
  fi
  if [[ -f /usr/share/doc/fzf/examples/completion.zsh ]]; then
    source /usr/share/doc/fzf/examples/completion.zsh
  fi
fi

# ---- Zsh Syntax Highlighting -----------------------------------------------
# Must be sourced BEFORE zsh-autosuggestions for correct color stacking
if [[ "$ZSH_OS" == "Darwin" ]]; then
  ZSH_HL="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ "$ZSH_OS" == "Linux" ]]; then
  ZSH_HL="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
[[ -f "$ZSH_HL" ]] && source "$ZSH_HL"

# Syntax highlighting color overrides (Catppuccin Mocha)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a6e3a1,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#89b4fa,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#cba6f7,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#fab387,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f38ba8'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#f5c2e7'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a6e3a1'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#fab387'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[path]='fg=#89dceb,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#89dceb'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#f9e2af'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#cba6f7'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f38ba8,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#89b4fa'

# ---- Zsh Autosuggestions ----------------------------------------------------
if [[ "$ZSH_OS" == "Darwin" ]]; then
  ZSH_AS="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif [[ "$ZSH_OS" == "Linux" ]]; then
  ZSH_AS="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
[[ -f "$ZSH_AS" ]] && source "$ZSH_AS"

# Autosuggestion styling
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#585b70,italic'   # Catppuccin surface2 (subtle ghost)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)          # history first, then completions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=50
ZSH_AUTOSUGGEST_USE_ASYNC=true
# Accept suggestion with CTRL+Space or Right arrow (already default → word: Alt+Right)
bindkey '^ ' autosuggest-accept                        # CTRL+Space → accept full suggestion
bindkey '^]' autosuggest-execute                       # CTRL+] → accept + execute

# ---- Zoxide -----------------------------------------------------------------
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
  # zi = interactive directory picker with fzf
fi

# ---- Eza (modern ls) --------------------------------------------------------
if command -v eza &>/dev/null; then
  alias ls='eza --icons --group-directories-first --color=always'
  alias ll='eza --icons --long --git --group-directories-first --color=always'
  alias la='eza --icons --long --git --all --group-directories-first --color=always'
  alias lt='eza --icons --tree --level=2 --color=always'
  alias lta='eza --icons --tree --level=2 --all --color=always'
  alias l='eza --icons --long --git --color=always'
else
  # Fallback to plain ls with color
  alias ls='ls --color=auto'
  alias ll='ls -lhF --color=auto'
  alias la='ls -lahF --color=auto'
fi

# ---- Bat (better cat) -------------------------------------------------------
if command -v bat &>/dev/null; then
  alias cat='bat --style=plain --paging=never'                                 # bat with full styling
elif command -v batcat &>/dev/null; then
  alias cat='batcat --style=plain --paging=never'
  alias bcat='batcat'                            
fi

# ---- Git shortcuts ----------------------------------------------------------
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias ga='git add .'
alias gc='git commit'
alias gp='git push -u origin main'
alias gpl='git pull'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'

# ---- Docker / Lazydocker ----------------------------------------------------
alias lzd='lazydocker'
alias lzg='lazygit'
alias dk='docker'
alias dkc='docker compose'

# ---- General aliases --------------------------------------------------------
alias grep='grep --color=auto'
alias vim='nvim'
alias v='nvim'
alias snvim='sudo -E nvim'
alias c='clear'
alias e='exit'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias path='echo -e ${PATH//:/\\n}'     # Pretty-print PATH entries
alias reload='exec zsh'                  # Reload this config
alias macansible='(cd ~/dots/ansible && ansible-playbook playbooks/mac.yml)'
alias linuxansible='(cd ~/dots/ansible && ansible-playbook playbooks/linux.yml)'

# ---- Editor -----------------------------------------------------------------
export EDITOR='nvim'
export VISUAL='nvim'

# ---- Language / Tool paths --------------------------------------------------
# Python (pyenv or system)
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  path=("$PYENV_ROOT/bin" $path)
  eval "$(pyenv init -)"
fi

# Node / npm global bins
[[ -d "$HOME/.npm-global/bin" ]] && path=("$HOME/.npm-global/bin" $path)

# Cargo (Rust)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ---- Starship prompt --------------------------------------------------------
# Starship is installed via Brewfile (macOS) or cargo/script (Linux)
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
  eval "$(starship init zsh)"
fi

# ---- Local overrides --------------------------------------------------------
# Source a local, machine-specific file that is NOT committed to the repo.
# Use this for secrets, API keys, or per-machine customizations.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
eval "$(mise activate zsh)"
eval "$(omp completions zsh)"
