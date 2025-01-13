--Oil.nvim is the great filesystem plugin
--

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    view_options = {
      show_hidden = true,
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  default_file_explorer = true,
  vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open parent directory', silent = true }),
}
