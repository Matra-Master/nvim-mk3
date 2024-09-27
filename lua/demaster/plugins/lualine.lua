return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'powerline',
      component_separators = { left = '', right = ''},
      -- section_separators = { left = '', right = ''},
      -- section_separators = { left = '◗', right = '◖'},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
    },
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff',
                    {'diagnostics', sources={'nvim_diagnostic', 'coc'}}},
      lualine_c = {
        {'filename', path = 3 }
      },
      lualine_x = {},
      lualine_y = {'fileformat', 'filetype'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
      lualine_y = {},
      lualine_z = {}
    },
    tabline = {},
    extensions = {}
  },
}
