return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for a better input and embedded terminal experience.
    -- To bypass: use your own `toggle` (if any), and override `opts.on_send` and `opts.on_opencode_not_found`.
    { 'folke/snacks.nvim', opts = { input = { enabled = true } } },
  },
  ---@type opencode.Config
  opts = {
    -- Your configuration, if any
  },
  keys = {
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>oa', function() require('opencode').ask('@cursor: ') end, desc = 'Ask [O]pencode about [C]ursor position', mode = 'n', },
    { '<leader>ob', function() require('opencode').ask('@buffer: ') end, desc = 'Ask [O]pencode about current [B]uffer', mode = 'n', },
    { '<leader>os', function() require('opencode').ask('@selection: ') end, desc = 'Ask [O]pencode about [S]election', mode = 'v', },
    { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
}
