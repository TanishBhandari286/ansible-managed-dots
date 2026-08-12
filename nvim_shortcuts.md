# Neovim Shortcuts

Everything below is what's actually active in this config (`.config/nvim`): LazyVim's
defaults, the extras enabled in `lazyvim.json`, and your own overrides in
`lua/config/keymaps.lua` / `lua/plugins/*.lua`. Leader key is `<Space>`.

Legend: `n` normal, `i` insert, `v`/`x` visual, `t` terminal, `c` command-line.

---

## Your custom overrides (`lua/config/keymaps.lua`)

These replace or add to LazyVim's defaults.

| Key | Mode | Action |
|---|---|---|
| `<C-/>` | n, t | Toggle terminal, always at the **current file's directory** (replaces LazyVim's root-dir terminal) |
| `<C-f>` | n | Find & replace in the whole file — opens `:%s/` |
| `<C-f>` | v | Find & replace in the selection only — opens `:s/` |

Deleted from LazyVim's defaults: `<leader>ft` / `<leader>fT` (root-dir / cwd terminal —
superseded by `<C-/>`).

---

## PLUGIN: snacks.nvim

`snacks.nvim` bundles many small features. What's enabled here: `bigfile`, `quickfile`,
`indent`, `scope`, `scroll`, `input`, `notifier`, `words`, `terminal`, `dashboard`,
`scratch`, `zen`, `picker`.

### Terminal
| Key | Mode | Action |
|---|---|---|
| `<C-/>` | n, t | Toggle terminal at current file's dir (your override, see above) |

### Git
| Key | Action |
|---|---|
| `<leader>gg` | Lazygit (repo root) |
| `<leader>gl` | Git log (repo root) |

### Notifications
| Key | Action |
|---|---|
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss all notifications |

### Picker — find & search
| Key | Action |
|---|---|
| `<leader><space>` | Find files (root dir) |
| `<leader>ff` | Find files (root dir) |
| `<leader>/` | Live grep (root dir) |

---

## PLUGIN: LSP (nvim-lspconfig + snacks picker)

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |

---

## PLUGIN: blink.cmp (completion)

Preset: `enter` (VS Code-style — top match highlighted, `<CR>` accepts it). The top
match is preselected so `<CR>` accepts it, EXCEPT when the word you just typed is a
bare number (e.g. `0`/`1` while writing a loop counter or return value) — in that case
nothing is preselected, so `<CR>` just inserts a newline instead of an unwanted
completion. `<C-y>` always force-accepts the current selection regardless.

| Key | Mode | Action |
|---|---|---|
| `<CR>` | i | Accept selected completion (falls back to newline if nothing selected) |
| `<Tab>` / `<S-Tab>` | i | Jump forward/backward through snippet placeholders |
| `<Up>` / `<Down>` or `<C-p>` / `<C-n>` | i | Select prev/next completion item |
| `<C-space>` | i | Show completion menu / toggle documentation |
| `<C-e>` | i | Cancel/close completion menu |

### Snippets (`.config/nvim/snippets/javascript.json`)
| Prefix | Expands to |
|---|---|
| `lg` | `console.log($1)` — cursor lands inside the parens |

---

## PLUGIN: oil.nvim

| Key | Action |
|---|---|
| `-` | Open parent directory as an editable buffer (rename/delete/create files by editing text) |

---

## PLUGIN: mason.nvim

| Key | Action |
|---|---|
| `<leader>cm` | Open Mason (LSP/linter/formatter installer UI) |

---

## Core editing (built into LazyVim, no plugin)

### Movement & editing
| Key | Mode | Action |
|---|---|---|
| `j`/`k`/`<Down>`/`<Up>` | n, v | Move by display line (respects wrap) |
| `<A-j>` / `<A-k>` | n, i, v | Move current line/selection down/up |
| `n` / `N` | n, v, o | Next/prev search result (always searches forward/backward, not direction-relative) |
| `<C-s>` | i, n, v | Save file |
| `gco` / `gcO` | n | Add comment below/above current line |

### Windows
| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move focus between splits |
| `<C-Up/Down/Left/Right>` | Resize current split |
| `<leader>-` | Split window below |
| `<leader>\|` | Split window right |
| `<leader>wd` | Close current window |

### Misc
| Key | Action |
|---|---|
| `<leader>cf` | Format buffer/selection |
| `<leader>ur` | Clear search highlight + redraw |
| `<leader>fn` | New file |
| `<leader>qq` | Quit all |
| `<leader>l` | Open Lazy (plugin manager) |
