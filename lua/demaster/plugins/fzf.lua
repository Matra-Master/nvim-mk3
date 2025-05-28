return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = { "nvim-tree/nvim-web-devicons" },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  vim.keymap.set('n', '<leader><leader>', function () require('fzf-lua').files() end, { desc = '[ ] Search Files' }),
  vim.keymap.set('n', '<leader>ff', function () require('fzf-lua').files() end, { desc = '[F]uzzy [F]ind Files' }),
  vim.keymap.set('n', '<leader>tg', function () require('fzf-lua').live_grep() end, { desc = '[F]uzzy [F]ind Files' }),
  vim.keymap.set('n', '<leader>fl', function () require('fzf-lua').buffers() end, { desc = '[F]ind: Buffers [L]ist' }),
}
