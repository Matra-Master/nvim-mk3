return {
  'sontungexpt/witch-line',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function(_, opts)
    require('witch-line').setup {
      components = {
        'mode',
        'git-branch',
        'git-diff',
        '%=',
        'os-uname',
        'filename',
        '%=',
        'diagnostics',
        'lsps-formatters',
        -- 'copilot',
        -- 'copilot-loading',
        'indent',
        'encoding',
        'pos-cursor',
        -- "pos-cursor-progress",
      },
    }
  end,
}
