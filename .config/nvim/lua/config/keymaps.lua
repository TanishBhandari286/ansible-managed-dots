-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Terminal: one key, always at the current file's directory. <C-/> opens it;
-- pressing it again closes the same terminal (Snacks.terminal.focus toggles
-- when called again on an already-focused terminal). Reuse the cwd stored on
-- the terminal buffer itself when closing from inside it, since `%` there
-- refers to the terminal buffer, not the file that opened it.
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")

local function toggle_file_dir_terminal()
  local cwd = vim.fn.expand("%:p:h")
  if vim.bo.buftype == "terminal" and vim.b.snacks_terminal then
    cwd = vim.b.snacks_terminal.cwd
  end
  return Snacks.terminal.focus(nil, { cwd = cwd })
end

vim.keymap.set({ "n", "t" }, "<C-/>", toggle_file_dir_terminal, { desc = "Terminal (file dir)" })
vim.keymap.set({ "n", "t" }, "<C-_>", toggle_file_dir_terminal, { desc = "which_key_ignore" })

-- Find & replace in the current file. Normal mode targets the whole file
-- (%s/...), visual mode targets the selection only (s/...). This overrides
-- the default <C-f> (scroll page down); use <PageDown>/<C-d> for that instead.
vim.keymap.set("n", "<C-f>", ":%s/", { desc = "Find & replace in file" })
vim.keymap.set("v", "<C-f>", ":s/", { desc = "Find & replace in selection" })

-- Shortcuts unbound per request -- these are plain global keymaps LazyVim's
-- core keymaps.lua sets directly (not part of any plugin's `keys` spec), so
-- vim.keymap.del removes them the same way <leader>ft/<leader>fT are removed
-- above. pcall-guarded since some (e.g. <leader>gG) only exist conditionally
-- (lazygit on PATH).
local unused_keymaps = {
  { "n", "<leader>bd" },
  { "n", "<leader>bo" },
  { "n", "<leader>bi" },
  { "n", "<leader>bD" },
  { "n", "<S-h>" },
  { "n", "<S-l>" },
  { "n", "[b" },
  { "n", "]b" },
  { "n", "<leader>bb" },
  { "n", "<leader>`" },
  { "n", "<leader>wm" },
  { "n", "<leader>uZ" },
  { "n", "<leader>uz" },
  { "n", "<leader>uf" },
  { "n", "<leader>uF" },
  { "n", "<leader>us" },
  { "n", "<leader>uw" },
  { "n", "<leader>uL" },
  { "n", "<leader>ud" },
  { "n", "<leader>ul" },
  { "n", "<leader>uc" },
  { "n", "<leader>uA" },
  { "n", "<leader>uT" },
  { "n", "<leader>ub" },
  { "n", "<leader>uD" },
  { "n", "<leader>ua" },
  { "n", "<leader>ug" },
  { "n", "<leader>uS" },
  { "n", "<leader>uh" },
  { "n", "<leader>dpp" },
  { "n", "<leader>dph" },
  { "n", "<leader>gG" },
  { "n", "<leader>gL" },
  { "n", "<leader>gb" },
  { "n", "<leader>gf" },
  { { "n", "x" }, "<leader>gB" },
  { { "n", "x" }, "<leader>gY" },
  { "n", "<leader>ui" },
  { "n", "<leader>uI" },
  { "n", "<leader>L" },
  { "n", "<leader>K" },
  { "n", "<leader><tab><tab>" },
  { "n", "<leader><tab>d" },
  { "n", "<leader><tab>]" },
  { "n", "<leader><tab>[" },
  { "n", "<leader><tab>f" },
  { "n", "<leader><tab>l" },
  { "n", "<leader><tab>o" },
  { "n", "<leader>xl" },
  { "n", "<leader>xq" },
  { "n", "[q" },
  { "n", "]q" },
  { "n", "]d" },
  { "n", "[d" },
  { "n", "]e" },
  { "n", "[e" },
  { "n", "]w" },
  { "n", "[w" },
  { "n", "<leader>cd" },
}

for _, k in ipairs(unused_keymaps) do
  pcall(vim.keymap.del, k[1], k[2])
end

-- Buffer-local, filetype-scoped -- vim.keymap.del can't reach it since it
-- isn't bound until a Lua buffer is opened. Snacks.keymap.del clears it from
-- the ft-scoped registry instead.
Snacks.keymap.del({ "n", "x" }, "<localleader>r", { ft = "lua" })
