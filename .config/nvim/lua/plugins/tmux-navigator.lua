-- Seamless <C-h/j/k/l> movement between Neovim splits and tmux panes.
-- Pairs with the matching bindings in ~/.config/tmux/tmux.conf. Outside
-- tmux these commands just fall back to plain window navigation.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
  keys = {
    { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window/pane" },
    { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window/pane" },
    { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window/pane" },
    { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window/pane" },
  },
}
