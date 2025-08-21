-- Note: Some git functionality now handled by mini.git in main mini.nvim config
-- Keeping vim-fugitive for advanced git features

return {
  'tpope/vim-fugitive',
  vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Open [G]it Fugitive [S]', silent = true }),
}
