#!/usr/bin/env bash
# Team setup script: Pi coding agent + DeepSeek V4 provider + starter plugins
# Usage: DEEPSEEK_API_KEY=sk-xxxx ./setup-pi-deepseek.sh
# (or just run it and paste the key when prompted)
set -euo pipefail

PI_DIR="$HOME/.pi/agent"
MODELS_JSON="$PI_DIR/models.json"

echo "== 1. Checking Node.js =="
if ! command -v node >/dev/null 2>&1; then
  echo "Node.js not found. Install Node.js >= 22.19 first: https://nodejs.org/en/download/"
  exit 1
fi
NODE_MAJOR=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_MAJOR" -lt 22 ]; then
  echo "Node.js $(node -v) found, but Pi requires >= 22.19. Please upgrade Node."
  exit 1
fi
echo "Node $(node -v) OK"

echo "== 2. Installing Pi coding agent =="
# Package moved from @mariozechner/pi-coding-agent to @earendil-works/pi-coding-agent
# as of v0.74.0 (May 2026). The old scope still resolves via a deprecation
# redirect, but new installs should use the current name.
if command -v pi >/dev/null 2>&1; then
  echo "Pi already installed: $(pi --version) — attempting self-update to current scope"
  pi update --self || echo "Self-update failed or not needed — continuing."
else
  npm install -g @earendil-works/pi-coding-agent
  echo "Installed: $(pi --version)"
fi

echo "== 3. Installing Claude Code CLI =="
if command -v claude >/dev/null 2>&1; then
  echo "Claude Code already installed: $(claude --version 2>/dev/null || echo present)"
else
  npm install -g @anthropic-ai/claude-code
  echo "Installed: $(claude --version 2>/dev/null || echo done)"
fi
if ! claude auth status >/dev/null 2>&1; then
  echo "NOTE: Claude Code isn't authenticated yet. Run 'claude' once after this script"
  echo "      finishes and log in with your Pro/Max subscription (opens a browser)."
fi

echo "== 4. Configuring DeepSeek provider =="
mkdir -p "$PI_DIR"
if [ -f "$MODELS_JSON" ] && grep -q '"deepseek"' "$MODELS_JSON" 2>/dev/null; then
  echo "DeepSeek provider already present in $MODELS_JSON — leaving it as-is."
else
  cat >"$MODELS_JSON" <<'EOF'
{
  "providers": {
    "deepseek": {
      "baseUrl": "https://api.deepseek.com",
      "api": "openai-completions",
      "apiKey": "$DEEPSEEK_API_KEY",
      "models": [
        {
          "id": "deepseek-v4-pro",
          "name": "DeepSeek V4 Pro",
          "contextWindow": 1000000,
          "maxTokens": 384000,
          "input": ["text"],
          "reasoning": true,
          "compat": {
            "requiresReasoningContentOnAssistantMessages": true,
            "thinkingFormat": "deepseek",
            "reasoningEffortMap": {"minimal": "high", "low": "high", "medium": "high", "high": "high", "xhigh": "max"}
          }
        },
        {
          "id": "deepseek-v4-flash",
          "name": "DeepSeek V4 Flash",
          "contextWindow": 1000000,
          "maxTokens": 384000,
          "input": ["text"],
          "reasoning": true,
          "compat": {
            "requiresReasoningContentOnAssistantMessages": true,
            "thinkingFormat": "deepseek",
            "reasoningEffortMap": {"minimal": "high", "low": "high", "medium": "high", "high": "high", "xhigh": "max"}
          }
        }
      ]
    }
  }
}
EOF
  echo "Wrote $MODELS_JSON"
fi

echo "== 5. DeepSeek API key =="
SECRETS_DIR="$HOME/.config/pi"
SECRETS_FILE="$SECRETS_DIR/secrets.env"
mkdir -p "$SECRETS_DIR"

if [ -f "$SECRETS_FILE" ] && grep -q "DEEPSEEK_API_KEY" "$SECRETS_FILE" 2>/dev/null; then
  echo "DEEPSEEK_API_KEY already present in $SECRETS_FILE — skipping prompt."
else
  if [ -z "${DEEPSEEK_API_KEY:-}" ]; then
    read -rsp "Paste your DeepSeek API key (from https://platform.deepseek.com/api_keys): " DEEPSEEK_API_KEY
    echo
  fi
  echo "export DEEPSEEK_API_KEY=\"$DEEPSEEK_API_KEY\"" >>"$SECRETS_FILE"
  echo "Wrote key to $SECRETS_FILE."
fi
chmod 600 "$SECRETS_FILE"

# IMPORTANT: this script always runs under bash (see shebang), so
# $ZSH_VERSION is never set here even if your login shell is zsh — that
# caused the "wrote to .bashrc but I use zsh" bug on macOS. Detect the
# actual login shell from $SHELL instead, and update every rc file that
# exists so it works regardless of which shell is active.
SOURCE_LINE="[ -f \"$SECRETS_FILE\" ] && source \"$SECRETS_FILE\""
RC_CANDIDATES=("$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile")
case "$(basename "${SHELL:-}")" in
zsh) PRIMARY_RC="$HOME/.zshrc" ;;
bash) PRIMARY_RC="$HOME/.bashrc" ;;
*) PRIMARY_RC="$HOME/.zshrc" ;; # macOS default since Catalina
esac
# Always update the primary one; only touch the others if they already exist.
touch "$PRIMARY_RC"
for RC in "${RC_CANDIDATES[@]}"; do
  [ "$RC" = "$PRIMARY_RC" ] || [ -f "$RC" ] || continue
  if ! grep -qF "$SECRETS_FILE" "$RC" 2>/dev/null; then
    echo "$SOURCE_LINE" >>"$RC"
    echo "Added a source line for $SECRETS_FILE to $RC — no secret in $RC itself."
  else
    echo "$RC already sources $SECRETS_FILE — leaving it as-is."
  fi
done

# If ~/.config is itself inside a tracked dotfiles repo, make sure this
# specific file is excluded rather than relying on people remembering.
if command -v git >/dev/null 2>&1; then
  REPO_ROOT=$(git -C "$SECRETS_DIR" rev-parse --show-toplevel 2>/dev/null || true)
  if [ -n "$REPO_ROOT" ]; then
    GITIGNORE="$REPO_ROOT/.gitignore"
    IGNORE_PATTERN="${SECRETS_FILE#"$REPO_ROOT"/}"
    if ! grep -qF "$IGNORE_PATTERN" "$GITIGNORE" 2>/dev/null; then
      echo "$IGNORE_PATTERN" >>"$GITIGNORE"
      echo "Added $IGNORE_PATTERN to $GITIGNORE (secrets.env detected inside a git repo at $REPO_ROOT)."
    fi
  fi
fi

export DEEPSEEK_API_KEY

echo "== 6. Installing starter plugins =="
# Plain indexed array, not associative — macOS ships bash 3.2 by default,
# which doesn't support `declare -A`.
PLUGINS=(
  "pi-sub-agent|npm:pi-sub-agent"
  "pi-deepseek-optimized|git:github.com/jrimmer/pi-deepseek-optimized"
  "pi-claude-code-provider|npm:pi-claude-code-provider"
  "context-mode|npm:context-mode"
  "pi-lens|npm:pi-lens"
  "pi-web-access|npm:pi-web-access"
  "pi-mcp-adapter|npm:pi-mcp-adapter"
  "rpiv-ask-user-question|npm:@juicesharp/rpiv-ask-user-question"
  "rpiv-todo|npm:@juicesharp/rpiv-todo"
  "plannotator|npm:@plannotator/pi-extension"
)
for entry in "${PLUGINS[@]}"; do
  name="${entry%%|*}"
  spec="${entry##*|}"
  echo "-- $name ($spec)"
  pi install "$spec" || echo "   FAILED — install manually later with: pi install $spec"
done

echo
echo "== Done =="
echo "Restart your shell (or 'source ~/.zshrc'), then:"
echo "  1) If Claude Code isn't authenticated yet: run 'claude' once and log in via browser"
echo "     (uses your Pro/Max subscription — draws from your normal plan limits)"
echo "  2) cd /path/to/project && pi"
echo "  /model    -> 'deepseek' for DeepSeek V4 Pro/Flash,"
echo "               or 'claude-code-provider' for Claude via your subscription (billed to your plan,"
echo "               not extra usage — it shells out to the real Claude Code CLI)"
echo "  /reload   -> loads the newly installed plugins"
echo "  /         -> confirm new slash commands are present (/sub-agent-settings, /todos, etc.)"
echo "Installed: pi-sub-agent, pi-deepseek-optimized, pi-claude-code-provider, context-mode,"
echo "           pi-lens, pi-web-access, pi-mcp-adapter, rpiv-ask-user-question, rpiv-todo,"
echo "           plannotator"
