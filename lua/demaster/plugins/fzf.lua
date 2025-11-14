return {
  'ibhagwan/fzf-lua',
  -- optional for icon support
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- or if using mini.icons/mini.nvim
  -- dependencies = { "echasnovski/mini.icons" },
  opts = {},
  vim.keymap.set('n', '<leader><leader>', ':FzfLua files<CR>', { desc = '[ ] Search Files' }),
  vim.keymap.set('n', '<leader>bl', ':FzfLua buffers<CR>', { desc = '[F]zfLua: Buffers [L]ist' }),
  vim.keymap.set('n', '<leader>ff', ':FzfLua files<CR>', { desc = '[F]zfLua: [F]ind Files' }),
  vim.keymap.set('n', '<leader>fj', ':FzfLua builtin<CR>', { desc = '[F]zfLua: [B]uiltin Lists' }),
  vim.keymap.set('n', '<leader>fk', ':FzfLua live_grep_native previewer=false<CR>', { desc = '[F]zfLua: [K] Live grep native' }),
  vim.keymap.set('n', '<leader>fl', ':FzfLua buffers<CR>', { desc = '[F]zfLua: Buffers [L]ist' }),
  vim.keymap.set('n', '<leader>fh', ':FzfLua helptags<CR>', { desc = '[F]zfLua: [H]elp tags' }),
  vim.keymap.set('n', '<leader>fm', ':FzfLua manpages<CR>', { desc = '[F]zfLua: [M]anpages search' }),
  vim.keymap.set('n', '<leader>fr', ':FzfLua resume<CR>', { desc = '[F]zfLua: [R]esume' }),
  vim.keymap.set('n', '<leader>fs', ':FzfLua lsp_document_symbols<CR>', { desc = '[F]zfLua: Buffers [L]ist' }),
  vim.keymap.set('n', '<leader>ft', ':FzfLua colorschemes<CR>', { desc = '[F]zfLua: [T]heme selection' }),
  vim.keymap.set('n', '<leader>tg', ':FzfLua live_grep_native previewer=false<CR>', { desc = '[F]zfLua: [F]ind inside Files' }),
  vim.keymap.set('n', '<leader>tt', ':FzfLua colorschemes<CR>', { desc = '[F]zfLua: [T]heme selection' }),
}
