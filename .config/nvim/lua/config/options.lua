-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Clipboard configuration with OSC 52 support for SSH.
-- Copy uses OSC 52 (works over SSH, no round trip needed). Paste uses pbpaste
-- directly instead of OSC 52's paste query: querying the terminal for
-- clipboard contents requires it to write an escape-sequence response back,
-- which tmux/Ghostty don't reliably deliver -- nvim then blocks on
-- "Waiting for OSC 52 response" until it times out. pbpaste reads the
-- clipboard locally and returns instantly.
local osc52 = require("vim.ui.clipboard.osc52")

vim.g.clipboard = {
  name = "osc52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = { "pbpaste" },
    ["*"] = { "pbpaste" },
  },
}

-- LazyVim defers clipboard handling at startup (clears the option, then
-- restores it later) to dodge the cost of probing for a system clipboard
-- tool. That cost doesn't apply here -- the provider above is a pure OSC 52
-- escape-sequence writer, nothing to probe -- so there's no reason to defer.
--
-- This used to re-apply `unnamedplus` on the `User VeryLazy` autocmd,
-- trying to win a race against LazyVim's own restore. Confirmed by
-- directly querying `:set clipboard?` after startup: that race was lost in
-- practice -- `clipboard` came back empty, so plain `y` never reached the
-- osc52 provider at all. Set it synchronously instead; this file already
-- runs after LazyVim's own options module, so there's no race to lose.
vim.opt.clipboard = "unnamedplus"
