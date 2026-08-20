return {
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
      lsp = {
        signature = {
          -- pyright auto-opens a signature popup on every trigger char/keystroke
          -- while typing a call. Turn that off; trigger it manually with gK / <C-k>.
          auto_open = {
            enabled = false,
          },
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
      },
    },
  },
}
