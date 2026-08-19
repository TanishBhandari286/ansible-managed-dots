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
            -- Preselect the top match (so <CR> accepts it) EXCEPT when the
            -- word just typed is a bare number, e.g. "0"/"1" while writing a
            -- loop counter or return value -- fuzzy-matching a lone digit
            -- against the whole completion list often preselects some long,
            -- irrelevant item, which <CR> would then insert instead of a
            -- newline. Everywhere else, Enter-to-accept still works as normal.
            preselect = function(ctx)
              local keyword = ctx.line:sub(ctx.bounds.start_col + 1, ctx.bounds.start_col + ctx.bounds.length)
              return not keyword:match("^%d+$")
            end,
            auto_insert = true,
          },
        },
        menu = { border = "single" },
        documentation = {
          auto_show = true,
          window = { border = "single" },
        },
      },
    },
  },
}
