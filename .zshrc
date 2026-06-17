# =============================================================================
# .zshrc — Minimal, clean Zsh configuration
# Managed by Ansible — edit at: dots/.zshrc
# =============================================================================

# ---- History ----------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # Ignore duplicate entries
setopt HIST_IGNORE_SPACE      # Ignore commands prefixed with a space
setopt SHARE_HISTORY          # Share history across all sessions
setopt APPEND_HISTORY         # Append rather than overwrite history file

# ---- Options ----------------------------------------------------------------
setopt AUTO_CD                # cd by typing directory name
setopt CORRECT                # Suggest corrections for misspelled commands
setopt EXTENDED_GLOB          # Enable extended globbing patterns
setopt NO_CASE_GLOB           # Case-insensitive globbing
unsetopt BEEP                 # No terminal bell

# ---- Completion system ------------------------------------------------------
autoload -Uz compinit
compinit -d "$HOME/.zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive tab completion

# ---- Key bindings -----------------------------------------------------------
bindkey -e                    # Emacs key bindings (works with readline-style apps)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ---- Path -------------------------------------------------------------------
typeset -U path               # Ensure unique entries in $PATH

# macOS Homebrew (Apple Silicon)
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
# macOS Homebrew (Intel)
[[ -f /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"

# User-local binaries
path=("$HOME/.local/bin" "$HOME/bin" $path)

# ---- Aliases ----------------------------------------------------------------
alias ls='ls --color=auto'
alias ll='ls -lAFh'
alias la='ls -A'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias du='du -sh'

# Git shortcuts
alias g='git'
alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'

# Neovim as default editor
alias vim='nvim'
alias vi='nvim'
export EDITOR='nvim'
export VISUAL='nvim'

# ---- Starship prompt --------------------------------------------------------
# Starship is installed via Brewfile (macOS) or cargo/apt (Linux)
if command -v starship &>/dev/null; then
  eval "$(starship init zsh)"
fi

# ---- FZF key bindings -------------------------------------------------------
# Loaded only if fzf is installed
[ -f "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# ---- Local overrides --------------------------------------------------------
# Source a local, machine-specific file that is NOT committed to the repo.
# Use this for secrets, API keys, or per-machine customizations.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
