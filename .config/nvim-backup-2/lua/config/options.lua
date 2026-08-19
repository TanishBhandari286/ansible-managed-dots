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

vim.opt.clipboard = "unnamedplus"
