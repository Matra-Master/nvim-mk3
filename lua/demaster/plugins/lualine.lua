local a_theme = {
  normal = {
    a = { fg = '#c1c1c1', bg = '#060f23', gui = 'bold' },
    b = { fg = '#c1c1c1', bg = '#060f23' },
    c = { fg = '#c1c1c1', bg = '#060f23' },
  },
  insert = {
    a = { fg = '#d0dfee', bg = '#060f23', gui = 'bold' },
    b = { fg = '#d0dfee', bg = '#060f23' },
    c = { fg = '#ffffff', bg = '#060f23' },
  },
  visual = {
    a = { fg = '#f5c2e7', bg = '#060f23', gui = 'bold' },
    b = { fg = '#f5c2e7', bg = '#060f23' },
    c = { fg = '#ffffff', bg = '#060f23' },
  },
  replace = {
    a = { fg = '#5f8787', bg = '#060f23', gui = 'bold' },
    b = { fg = '#5f8787', bg = '#060f23' },
    c = { fg = '#ffffff', bg = '#060f23' },
  },
  command = {
    a = { fg = '#fbcb97', bg = '#060f23', gui = 'bold' },
    b = { fg = '#fbcb97', bg = '#060f23' },
    c = { fg = '#ffffff', bg = '#060f23' },
  },
  inactive = {
    a = { fg = '#6c7086', bg = '#060f23' },
    b = { fg = '#6c7086', bg = '#060f23' },
    c = { fg = '#6c7086', bg = '#060f23' },
  },
}
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = a_theme,
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
