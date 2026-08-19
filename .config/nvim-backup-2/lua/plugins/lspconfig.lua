-- Unused LSP shortcuts, unbound so they stop cluttering which-key. These are
-- buffer-local keymaps LazyVim sets on LspAttach (lsp/init.lua and the
-- snacks_picker extra), so a plain vim.keymap.del at startup can't reach them
-- -- instead, re-declaring the same lhs/mode with `false` as the rhs in the
-- servers["*"].keys list tells lazy.nvim's keys handler to never bind it.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            { "gr", false },
            { "gI", false },
            { "gy", false },
            { "gai", false },
            { "gao", false },
            { "gK", false },
            { "<c-k>", false, mode = "i" },
            { "<leader>ca", false, mode = { "n", "x" } },
            { "<leader>cA", false },
            { "<leader>cc", false, mode = { "n", "x" } },
            { "<leader>cC", false },
            { "<leader>cr", false },
            { "<leader>cR", false },
            { "<leader>cl", false },
            { "<leader>ss", false },
            { "<leader>sS", false },
            { "]]", false },
            { "[[", false },
            { "<a-n>", false },
            { "<a-p>", false },
          },
        },
      },
    },
  },
}
