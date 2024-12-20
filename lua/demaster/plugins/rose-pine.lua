return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000, -- Make sure to load this before all the other start plugins.
  init = function()
    -- You can configure highlights by doing something like:
    vim.cmd.hi 'Comment gui=none'

    -- setup here
    require('rose-pine').setup {
      transparent_background = true, -- disables setting the background color.
      highlight_groups = {
        TelescopeBorder = { fg = "highlight_high", bg = "none" },
        TelescopeNormal = { bg = "none" },
        TelescopePromptNormal = { bg = "base" },
        TelescopeResultsNormal = { fg = "subtle", bg = "none" },
        TelescopeSelection = { fg = "text", bg = "base" },
        TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
      },
    }
    -- Load the colorscheme here.
    vim.cmd.colorscheme 'rose-pine'

  end,
}
