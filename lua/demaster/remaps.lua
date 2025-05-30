-- [[ Keymaps ]]
-- Here will go my default usefull nvim remaps.
-- The specifics for each plugin will be with the plugin itself.

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list', silent = true })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
--vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<C-w>n', '<C-\\><C-n>', {desc = 'Exit Terminal mode'})
vim.keymap.set("n", "<leader>te", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end, {desc = "Small [TE]rminal open"})

--
--  See `:help wincmd` for a list of all window commands
-- [[Fran's specials]]
--
-- vim.keymap.set("n", "<leader>a", ":wincmd h<CR>", {desc = 'Move to left window', silent = true })
-- vim.keymap.set("n", "<leader>s", ":wincmd j<CR>", {desc = 'Move to window down', silent = true })
-- vim.keymap.set("n", "<leader>w", ":wincmd k<CR>", {desc = 'Move to window up', silent = true })
-- vim.keymap.set("n", "<leader>d", ":wincmd l<CR>", {desc = 'Move to right window', silent = true })

vim.keymap.set('n', '<C-j>', ':cnext<CR>', { desc = 'Go to next error in the C error List' })
vim.keymap.set('n', '<C-k>', ':cprevious<CR>', { desc = 'Go to previous error in the C error List' })

--Resize splits
vim.keymap.set('n', '<leader>=', ':vertical resize +5<CR>', { desc = 'Resize vertical buffer +5', silent = true })
vim.keymap.set('n', '<leader>-', ':vertical resize -5<CR>', { desc = 'Resize vertical buffer -5', silent = true })

--Buffers List
vim.keymap.set('n', '<Leader>bp', ':b# <CR>', { desc = '[B]uffers: Go to [P]revious file', silent = true })

--jq json formating
vim.keymap.set('v', '<Leader>vjq', ':.!jq<CR>', { desc = 'Visual format of Json text', silent = true })

-- Reselect visual selection after indenting
vim.keymap.set('v', '<', '<gv', { desc = '', silent = true })
vim.keymap.set('v', '>', '>gv', { desc = '', silent = true })

-- Easy insertion of trailing ; or , from instert mode
vim.keymap.set('i', ';;', '<Esc>A;<Esc>', { desc = 'Insert a ; at the end of a line', silent = true })
vim.keymap.set('i', ',,', '<Esc>A,<Esc>', { desc = 'Insert a , at the end of a line', silent = true })

--Never used these much, have to check for conflicts with kickstart
--nnoremap("<Leader>cl", ":s///gn<CR>", {desc = '[C]ount ocurrences of last searched pattern in [L]ine'})
--nnoremap("<Leader>tw", ":%s/\\s\\+$//e<CR>", {desc = 'Remove [T]railing [W]hitespaces in file'})
--

--
-- Yank remaps
--
--Greates remap ever
--Delete to void what you have selected and paste your previous yanked stuff
vim.keymap.set('v', '<leader>p', '"_dP', { desc = '', silent = true })
-- Copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { desc = '[Y]ank to clipboard', silent = true })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = '[Y]ank line to clipboard', silent = true })
vim.keymap.set('n', '<leader>y', '"+y', { desc = '[Y]ank to clipboard', silent = true })

-- Paste from clipboard
vim.keymap.set('n', '<leader>p', '"+p', { desc = '[P]aste from clipboard', silent = true })
vim.keymap.set('n', '<leader>P', '"+P', { desc = '[P]aste from clipboard', silent = true })
vim.keymap.set('v', '<leader>P', '"+P', { desc = '[P]aste from clipboard', silent = true })

--Make the file executable right now!
vim.keymap.set("n", "<leader>x", ":silent !chmod u+x %<CR>", {desc = 'Make file e[X]ecutable'})
vim.keymap.set("v", "<leader>x", ":lua<CR>", {desc = 'E[X]ecute a Lua snippet'})
--
--     Simple tab Splits
--
vim.keymap.set('n', '<leader>zo', ':tab split<CR>', { desc = '[O]pen buffer in a tab' })
vim.keymap.set('n', '<leader>zp', ':tab close<CR>', { desc = 'CLose tab' })
