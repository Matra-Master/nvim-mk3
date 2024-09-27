return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function ()
    local harpoon = require("harpoon")
    vim.keymap.set('n', '<leader>jj', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = '[J] Quick menu', silent = true })
    vim.keymap.set("n", "<leader>m", function() harpoon:list():add() end, { desc = 'Mark file', silent = true })

    vim.keymap.set("n", "<A-f>", function() harpoon:list():select(1) end, { desc = 'Select item 1', silent = true })
    vim.keymap.set("n", "<A-d>", function() harpoon:list():select(2) end, { desc = 'Select item 2', silent = true })
    vim.keymap.set("n", "<A-s>", function() harpoon:list():select(3) end, { desc = 'Select item 3', silent = true })
    vim.keymap.set("n", "<A-a>", function() harpoon:list():select(4) end, { desc = 'Select item 4', silent = true })
  end,

}
