--Oil.nvim is the great filesystem plugin
--

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    win_options = {
      number = false,
    },
    view_options = {
      show_hidden = true,
    },
    columns = { "icon" },
    win_options = {
      wrap = false,
      number = false,
      signcolumn = "no",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    buf_options = {
      buflisted = false,
      bufhidden = 'hide',
    },
    float = {
      -- Padding around the floating window
      padding = 1,
      max_width = 0.25,
      max_height = 0.60,
      border = 'rounded',
      win_options = {
        winblend = 0,
      },
      -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
      get_win_title = nil,
      -- preview_split: Split direction: "auto", "left", "right", "above", "below".
      preview_split = 'below',
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      override = function(conf)
        return conf
      end,
      keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in a Vertical split" },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in a Horizontal split" },
      }

    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  default_file_explorer = true,
  -- vim.keymap.set('n', '<leader>e', ':Oil<CR>', { desc = 'Open parent directory', silent = true }),
  vim.keymap.set('n', '-', ':Oil<CR>', { desc = 'Open parent directory', silent = true }),
  vim.keymap.set('n', '<leader>_', ':lua require("oil").open_float()<CR>', { desc = 'Open parent directory', silent = true }),
  vim.keymap.set("n", "<leader>-", function()
    vim.cmd.vnew()
    vim.cmd.Oil()
    vim.cmd.wincmd("H")
    local window_width = math.floor((vim.api.nvim_win_get_width(0) * 2) /4);
    vim.api.nvim_win_set_width(0, window_width)
  end, {desc = "Open parent directory"})
}
