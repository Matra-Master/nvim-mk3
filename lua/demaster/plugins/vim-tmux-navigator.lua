return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
  },
  keys = {
    { "<leader>a", "<cmd>TmuxNavigateLeft<cr>", {desc = 'Move to left window', silent = true } },
    { "<leader>s", "<cmd>TmuxNavigateDown<cr>", {desc = 'Move to window down', silent = true } },
    { "<leader>w", "<cmd>TmuxNavigateUp<cr>", {desc = 'Move to window up', silent = true } },
    { "<leader>d", "<cmd>TmuxNavigateRight<cr>", {desc = 'Move to right window', silent = true } },
  },
}
