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
