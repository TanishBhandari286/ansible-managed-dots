return {
  {
    "folke/snacks.nvim",
    opts = {
      scratch = { enabled = true },
      zen = { enabled = true },
    },
    keys = {
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    },
  },
}
