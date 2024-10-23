return {
  'tpope/vim-fugitive',
  vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Open [G]it Fugitive [S]', silent = true }),
}
