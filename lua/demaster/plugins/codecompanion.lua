return {
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'github/copilot.vim',
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'copilot',
        },
        inline = {
          adapter = 'copilot',
        },
      },
    },
    adapters = {},
    -- adapters = {
    --   copilot = function ()
    --     return require('codecompanion.adapters').extend('copilot', {
    --       env = {
    --         api_key = '',
    --       },
    --     })
    --   end,
    -- },
    config = function(_, opts)
      require('codecompanion').setup(opts)
      local progress = require 'fidget.progress'
      local handles = {}
      local group = vim.api.nvim_create_augroup('CodeCompanionFidget', {})

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestStarted',
        group = group,
        callback = function(e)
          handles[e.data.id] = progress.handle.create {
            title = 'CodeCompanion',
            message = 'Thinking...',
            lsp_client = { name = e.data.adapter.formatted_name },
          }
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionRequestFinished',
        group = group,
        callback = function(e)
          local h = handles[e.data.id]
          if h then
            h.message = e.data.status == 'success' and 'Done' or 'Failed'
            h:finish()
            handles[e.data.id] = nil
          end
        end,
      })
    end,
  },
  vim.keymap.set('n', '<leader>c', ':CodeCompanionActions<CR>', { desc = '[C]odeCompanion actions list' }),
  vim.keymap.set('n', '<leader>cc', ':CodeCompanionChat Toggle<CR>', { desc = '[C]odeCompanion [C]hat Toggle' }),
  vim.keymap.set('v', '<leader>c', ':CodeCompanion ', { desc = '[C]odeCompanion Inline Assist' }),
  vim.keymap.set('v', '<leader>cj', ':CodeCompanion /tests', { desc = '[C]odeCompanion write a test' }),
}
