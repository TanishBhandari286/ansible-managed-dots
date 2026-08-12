# =============================================================================
# .zshrc — Feature-rich Zsh configuration
# Managed by Ansible — edit at: dots/.zshrc
# =============================================================================
# Platform: Linux + macOS (Homebrew on both)
# Theme:    Tokyo Night (Storm) — matches the Ghostty "TokyoNight Storm" theme
# Prompt:   starship
# Features: fzf completions, syntax highlighting, autosuggestions, zoxide, eza
# =============================================================================

# ---- OS Detection & Homebrew prefix -----------------------------------------
export ZSH_OS="$(uname -s)"
if [[ "$ZSH_OS" == "Darwin" ]]; then
  BREW_PREFIX="/opt/homebrew"
elif [[ -d /home/linuxbrew/.linuxbrew ]]; then
  BREW_PREFIX="/home/linuxbrew/.linuxbrew"
else
  BREW_PREFIX="/usr/local"
fi

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
# Homebrew first — takes priority over system packages
path=("$BREW_PREFIX/bin" "$BREW_PREFIX/sbin" "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin" $path)

# ---- Completion styling (Tokyo Night) ----------------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format '%F{#9d7cd8}── %d ──%f'
zstyle ':completion:*:warnings' format '%F{#f7768e}No matches for: %d%f'
zstyle ':completion:*:messages' format '%F{#9ece6a}%d%f'
zstyle ':completion:*:corrections' format '%F{#ff9e64}%d (errors: %e)%f'
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
# Tokyo Night (Storm) color palette for fzf
export FZF_DEFAULT_OPTS="
  --color=bg+:#292e42,bg:#24283b,spinner:#7dcfff,hl:#f7768e
  --color=fg:#c0caf5,header:#f7768e,info:#9d7cd8,pointer:#7dcfff
  --color=marker:#7aa2f7,fg+:#c0caf5,prompt:#9d7cd8,hl+:#f7768e
  --color=selected-bg:#292e42
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
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
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

# fzf key-bindings + completion from Homebrew
[[ -f "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh" ]] && source "$BREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
[[ -f "$BREW_PREFIX/opt/fzf/shell/completion.zsh" ]] && source "$BREW_PREFIX/opt/fzf/shell/completion.zsh"

# ---- Zsh Syntax Highlighting -----------------------------------------------
# Must be sourced BEFORE zsh-autosuggestions for correct color stacking
ZSH_HL="$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$ZSH_HL" ]] && source "$ZSH_HL"

# Syntax highlighting color overrides (Tokyo Night Storm)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#9ece6a,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#9ece6a,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7aa2f7,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=#9d7cd8,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#ff9e64,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#f7768e'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ff007c'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ff9e64'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#9d7cd8'
ZSH_HIGHLIGHT_STYLES[path]='fg=#7dcfff,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#7dcfff'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#e0af68'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#bb9af7'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#7aa2f7'

# ---- Zsh Autosuggestions ----------------------------------------------------
ZSH_AS="$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_AS" ]] && source "$ZSH_AS"

# Autosuggestion styling
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#565f89,italic'   # Tokyo Night "comment" (subtle ghost)
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

# nvm (Node is managed via nvm on Linux)
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

# Cargo (Rust)
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# ---- Mise (polyglot runtime manager) ----------------------------------------
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# ---- OMP (oh-my-pi coding agent) completions --------------------------------
command -v omp &>/dev/null && eval "$(omp completions zsh)"

# ---- Starship prompt ---------------------------------------------------------
if command -v starship &>/dev/null; then
  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
  eval "$(starship init zsh)"
fi

# ---- Local overrides --------------------------------------------------------
# Source a local, machine-specific file that is NOT committed to the repo.
# Use this for secrets, API keys, or per-machine customizations.
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
