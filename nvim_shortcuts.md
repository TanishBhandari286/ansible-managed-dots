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

### Buffers & windows
| Key | Action |
|---|---|
| `<leader>bd` | Delete current buffer |
| `<leader>bo` | Delete all other buffers |
| `<leader>bi` | Delete invisible buffers |
| `<leader>wm` / `<leader>uZ` | Toggle window zoom (maximize split) |

### Scratch buffer / Zen
| Key | Action |
|---|---|
| `<leader>.` | Toggle scratch buffer (scratchpad you can dump text into) |
| `<leader>S` | Pick a scratch buffer |
| `<leader>z` | Toggle Zen mode |
| `<leader>uz` | Toggle Zen mode (LazyVim's own binding, same effect) |

### Git
| Key | Action |
|---|---|
| `<leader>gg` | Lazygit (repo root) |
| `<leader>gG` | Lazygit (cwd) |
| `<leader>gl` | Git log (repo root) |
| `<leader>gL` | Git log (cwd) |
| `<leader>gb` | Git blame for current line |
| `<leader>gf` | Git history for current file |
| `<leader>gB` | Open current line on GitHub/GitLab in browser |
| `<leader>gY` | Copy current line's GitHub/GitLab URL to clipboard |
| `<leader>gd` | Git diff (hunks, via picker) |
| `<leader>gD` | Git diff against origin (via picker) |
| `<leader>gs` | Git status (via picker) |
| `<leader>gS` | Git stash (via picker) |
| `<leader>gi` / `<leader>gI` | GitHub issues, open / all |
| `<leader>gp` / `<leader>gP` | GitHub PRs, open / all |

### Notifications
| Key | Action |
|---|---|
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss all notifications |

### Toggles (all via `Snacks.toggle`)
| Key | Toggles |
|---|---|
| `<leader>uf` / `<leader>uF` | Auto-format on save (buffer / global) |
| `<leader>us` | Spelling |
| `<leader>uw` | Line wrap |
| `<leader>uL` | Relative line numbers |
| `<leader>ud` | Diagnostics |
| `<leader>ul` | Line numbers |
| `<leader>uc` | Conceal level |
| `<leader>uA` | Tabline |
| `<leader>uT` | Treesitter highlighting |
| `<leader>ub` | Dark/light background |
| `<leader>uD` | Dim inactive code |
| `<leader>ua` | Animations |
| `<leader>ug` | Indent guides |
| `<leader>uS` | Smooth scroll |
| `<leader>uh` | Inlay hints |
| `<leader>dpp` / `<leader>dph` | Profiler / profiler highlights |

### Reference jumping (`words`)
| Key | Action |
|---|---|
| `]]` / `[[` | Jump to next/prev reference of symbol under cursor |
| `<A-n>` / `<A-p>` | Same, but wraps/cycles |

### Picker — find & search (newly enabled)
| Key | Action |
|---|---|
| `<leader><space>` | Find files (root dir) |
| `<leader>ff` | Find files (root dir) |
| `<leader>fF` | Find files (cwd) |
| `<leader>fg` | Find files (git-tracked only) |
| `<leader>fr` | Recent files |
| `<leader>fR` | Recent files (cwd only) |
| `<leader>fb` | List buffers |
| `<leader>fB` | List buffers (incl. hidden) |
| `<leader>fc` | Find a config file |
| `<leader>fp` | Projects |
| `<leader>/` | Live grep (root dir) |
| `<leader>sg` | Live grep (root dir) |
| `<leader>sG` | Live grep (cwd) |
| `<leader>sw` | Grep word/selection under cursor (root dir) |
| `<leader>sW` | Grep word/selection under cursor (cwd) |
| `<leader>sb` | Search lines in current buffer |
| `<leader>sB` | Grep across open buffers |
| `<leader>,` | List buffers |
| `<leader>:` | Command history |

### Picker — everything else
| Key | Action |
|---|---|
| `<leader>sd` / `<leader>sD` | Diagnostics (workspace / buffer) |
| `<leader>sh` | Help pages |
| `<leader>sH` | Highlight groups |
| `<leader>si` | Icons |
| `<leader>sj` | Jump list |
| `<leader>sk` | Keymaps |
| `<leader>sl` | Location list |
| `<leader>sq` | Quickfix list |
| `<leader>sm` | Marks |
| `<leader>sM` | Man pages |
| `<leader>sR` | Resume last picker |
| `<leader>su` | Undo tree |
| `<leader>sc` / `<leader>sC` | Command history / commands list |
| `<leader>sp` | Search plugin specs |
| `<leader>s"` | Registers |
| `<leader>s/` | Search history |
| `<leader>sa` | Autocmds |
| `<leader>st` / `<leader>sT` | TODO comments (all / TODO+FIX+FIXME only) |
| `<leader>uC` | Colorschemes |
| Inside any picker: `<A-c>` | Toggle picker's cwd between root dir and actual cwd |

### Rename / misc
| Key | Action |
|---|---|
| `<leader>cR` | Rename current file (and update imports, if LSP supports it) |
| `<localleader>r` | Run current Lua file/selection (Lua files only) |

---

## PLUGIN: LSP (nvim-lspconfig + snacks picker)

With the picker extra enabled, these open a fuzzy **Snacks picker** list instead of a
plain quickfix list.

| Key | Mode | Action |
|---|---|---|
| `gd` | n | Go to definition |
| `gr` | n | Find references |
| `gI` | n | Go to implementation |
| `gy` | n | Go to type definition |
| `gai` / `gao` | n | Incoming / outgoing call hierarchy |
| `gK` | n | Signature help |
| `<C-k>` | i | Signature help |
| `<leader>ca` | n, v | Code action |
| `<leader>cA` | n | Source action |
| `<leader>cc` | n, v | Run codelens |
| `<leader>cC` | n | Refresh & display codelens |
| `<leader>cr` | n | Rename symbol |
| `<leader>cl` | n | LSP info |
| `<leader>ss` | n | Document symbols |
| `<leader>sS` | n | Workspace symbols |
| `]d` / `[d` | n | Next/prev diagnostic |
| `]e` / `[e` | n | Next/prev error |
| `]w` / `[w` | n | Next/prev warning |
| `<leader>cd` | n | Show diagnostic under cursor (float) |

---

## PLUGIN: blink.cmp (completion)

Preset: `enter` (VS Code-style — top match highlighted, `<CR>` accepts it). Note:
`preselect` is off, so nothing is auto-highlighted until you actually navigate —
plain `<CR>` on a fresh completion menu just inserts a newline.

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

## PLUGIN: language extras

| Key | Filetype | Action |
|---|---|---|
| `<leader>ta` | `yaml.ansible` | Run Ansible playbook/role |
| `<leader>cv` | `python` | Select Python virtualenv |
| `<leader>dPt` | `python` | Debug: run test method under cursor |
| `<leader>dPc` | `python` | Debug: run test class under cursor |

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

### Buffers & tabs
| Key | Action |
|---|---|
| `<S-h>` / `<S-l>` or `[b` / `]b` | Prev/next buffer |
| `<leader>bb` or `` <leader>` `` | Switch to last buffer |
| `<leader>bD` | Delete buffer and its window |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>d` | Close tab |
| `<leader><tab>]` / `[` | Next/prev tab |
| `<leader><tab>f` / `l` | First/last tab |
| `<leader><tab>o` | Close all other tabs |

### Diagnostics / quickfix
| Key | Action |
|---|---|
| `<leader>xl` | Toggle location list |
| `<leader>xq` | Toggle quickfix list |
| `[q` / `]q` | Prev/next quickfix item |

### Misc
| Key | Action |
|---|---|
| `<leader>cf` | Format buffer/selection |
| `<leader>ur` | Clear search highlight + redraw |
| `<leader>fn` | New file |
| `<leader>qq` | Quit all |
| `<leader>l` | Open Lazy (plugin manager) |
| `<leader>L` | LazyVim changelog |
| `<leader>K` | Show keyword help (`man`/docs for word under cursor) |
| `<leader>ui` | Inspect highlight groups under cursor |
| `<leader>uI` | Inspect Treesitter tree |
