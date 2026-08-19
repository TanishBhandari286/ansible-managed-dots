return {
  {
    "saghen/blink.cmp",
    opts = {
      snippets = {
        search_paths = { vim.fn.stdpath("config") .. "/snippets" },
      },
      keymap = { preset = "enter" },
      completion = {
        list = {
          selection = {
            preselect = function(ctx)
              local keyword = ctx.line:sub(ctx.bounds.start_col + 1, ctx.bounds.start_col + ctx.bounds.length)
              return not keyword:match("^%d+$")
            end,
            auto_insert = true,
          },
        },
        menu = {
          border = "single",
          min_width = 45,
          max_height = 10,
          draw = {
            padding = { 1, 2 },
            gap = 4,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = "single",
            min_width = 25,
            max_width = 60,
            max_height = 20,
          },
        },
      },
    },
  },
}
