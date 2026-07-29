return {
  {
    "saghen/blink.cmp",
    opts = {
      snippets = {
        -- This tells blink to look for VSCode-style snippets in your config folder
        -- Note: LazyVim 2026 often handles this, but explicitly adding it ensures it works.
        search_paths = { vim.fn.stdpath("config") .. "/snippets" },
      },
      -- VS Code style: top match highlighted automatically, <CR> accepts it.
      keymap = { preset = "enter" },
      completion = {
        list = {
          selection = {
            preselect = true,
            auto_insert = true,
          },
        },
      },
    },
  },
}
