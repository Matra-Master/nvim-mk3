-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
require 'demaster'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- guess-indent replaced by mini.indentscope - see mini.nvim configuration above

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to automatically pass options to a plugin's `setup()` function, forcing the plugin to be loaded.
  --

  -- Alternatively, use `config = function() ... end` for full control over the configuration.
  -- If you prefer to call `setup` explicitly, use:
  --    {
  --        'lewis6991/gitsigns.nvim',
  --        config = function()
  --            require('gitsigns').setup({
  --                -- Your gitsigns configuration here
  --            })
  --        end,
  --    }
  --
  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`.
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- gitsigns replaced by mini.diff - see mini.nvim configuration above

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  -- which-key replaced by mini.clue - see mini.nvim configuration above

  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  -- Telescope replaced by mini.pick - see mini.nvim configuration above

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

          -- Find references for the word under your cursor.
          map('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('<leader>gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('<leader>gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('<leader>gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            return client:supports_method(method, bufnr)
          end

          -- Later Fran
          map('<leader>gp', function()
            vim.diagnostic.jump { count = -1, float = true }
          end, '[G]o to [P]revious Diagnostic')
          map('<leader>gn', function()
            vim.diagnostic.jump { count = 1, float = true }
          end, '[G]o to [N]ext Diagnostic')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>lh', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        ts_ls = {
          root_dir = require('lspconfig').util.root_pattern('tsconfig.json', 'jsconfig.json', 'package.json', '.git'),
          single_file_support = true,
        }, --typescript
        pyright = {}, --python
        --rust_analyzer = {},
        intelephense = {}, --php
        ansiblels = {},
        shellcheck = {},
        -- fish_lsp = {},
        html = {},
        -- htmx = {},
        dockerls = {},
        -- denols = { root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc') },
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                kubernetes = 'k8s-*.yaml',
                ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
                ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
                ['http://json.schemastore.org/ansible-stable-2.9'] = 'roles/tasks/**/*.{yml,yaml}',
                ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
                ['http://json.schemastore.org/kustomization'] = 'kustomization.{yml,yaml}',
                ['http://json.schemastore.org/chart'] = 'Chart.{yml,yaml}',
                ['http://json.schemastore.org/circleciconfig'] = '.circleci/**/*.{yml,yaml}',
              },
            },
          },
        },
        -- clangd = {},
        -- gopls = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        tailwindcss = {
          filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue' },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'shellcheck',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = {},
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>bf',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = false,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { 'deno_fmt' },
      },
    },
  },

  { -- Autocompletion
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      -- Snippet Engine
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip').filetype_extend('javascriptreact', { 'html' })
              require('luasnip').filetype_extend('typescriptreact', { 'html' })
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        vim.keymap.set({ 'i', 's' }, '<c-k>', function()
          if require('luasnip').expand_or_locally_jumpable() then
            require('luasnip').expand_or_jump()
          end
        end, { desc = 'Code: Expand Snippet', silent = true }),
        opts = {},
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- For an understanding of why the 'default' preset is recommended,
        -- you will need to read `:help ins-completion`
        preset = 'enter',

        -- See :h blink-cmp-config-keymap for defining your own keymap
        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --  https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },

      appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
        list = {
          selection = {
            preselect = true,
            auto_insert = false,
          },
        },
        -- Fran mod: shows completion like in nvim-cmp. I don't like it but it's a good example
        -- menu = { draw = { columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } } } },
      },

      sources = {
        -- Fran mod
        -- default = { 'lsp', 'path', 'snippets', 'lazydev', 'nvim_lsp', 'nvim_lua' },
        default = { 'lazydev', 'lsp', 'snippets', 'path' },
        per_filetype = {
          sql = { 'snippets', 'dadbod', 'buffer' },
          codecompanion = { 'codecompanion' },
        },
        providers = {
          lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100 },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          lsp = {
            transform_items = function(_, items)
              for _, item in ipairs(items) do
                item.kind_icon = 'λ'
                item.kind_name = 'LSP'
              end
              return items
            end,
          },
        },
      },
      snippets = { preset = 'luasnip' },

      -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
      -- which automatically downloads a prebuilt binary when enabled.
      --
      -- By default, we use the Lua implementation instead, but you may enable
      -- the rust implementation via `'prefer_rust_with_warning'`
      --
      -- See :h blink-cmp-config-fuzzy for more information
      fuzzy = { implementation = 'lua' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    --priority = 1000, -- Make sure to load this before all the other start plugins.
    -- init = function()
    --   -- setup here
    --   require('catppuccin').setup {
    --     flavour = 'mocha', -- latte, frappe, macchiato, mocha
    --     transparent_background = true, -- disables setting the background color.
    --     -- term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    --     highlight_overrides = {
    --       all = function(colors)
    --         return {
    --           LineNr = { fg = colors.text },
    --         }
    --       end,
    --     },
    --   }
    --   -- Load the colorscheme here.
    --   -- vim.cmd.colorscheme 'catppuccin'
    --
    --   -- You can configure highlights by doing something like:
    --   -- vim.cmd.hi 'Comment gui=none'
    -- end,
  },

  -- todo-comments replaced by mini.hipatterns - see mini.nvim configuration above

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Replaces: nvim-autopairs
      -- Automatic insertion/deletion of bracket pairs
      require('mini.pairs').setup()

      -- Better Around/Inside textobjects
      -- FUCK ME THIS IS GOLDEN
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Replaces: lualine.nvim
      -- Simple and easy statusline with custom configuration
      local statusline = require 'mini.statusline'
      statusline.setup { 
        use_icons = vim.g.have_nerd_font,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git           = statusline.section_git({ trunc_width = 75 })
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            local location      = statusline.section_location({ trunc_width = 75 })

            return statusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = 'MiniStatuslineDevinfo',  strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { location } },
            })
          end,
        }
      }

      -- Replaces: gitsigns.nvim  
      -- Git integration with signs and hunks
      require('mini.diff').setup({
        view = {
          style = 'sign',
          signs = { add = '+', change = '~', delete = '_' },
        },
        mappings = {
          apply = '<leader>ha',
          reset = '<leader>hr',
          textobject = '<leader>hh',
          goto_first = '[H',
          goto_prev = '[h',
          goto_next = ']h',
          goto_last = ']H',
        },
      })

      -- Additional git keymaps for consistency with gitsigns
      vim.keymap.set('n', '<leader>hs', '<leader>ha', { desc = 'git [s]tage hunk', remap = true })
      vim.keymap.set('n', '<leader>hp', function()
        require('mini.diff').toggle_overlay()
      end, { desc = 'git [p]review hunk' })
      vim.keymap.set('n', '<leader>hb', function()
        require('mini.git').show_at_cursor()
      end, { desc = 'git [b]lame line' })

      -- Replaces: telescope.nvim and fzf-lua
      -- Fast and flexible picker
      require('mini.pick').setup({
        mappings = {
          caret_left  = '<Left>',
          caret_right = '<Right>',
          choose      = '<CR>',
          choose_in_split = '<C-s>',
          choose_in_tabpage = '<C-t>',
          choose_in_vsplit = '<C-v>',
          choose_marked = '<M-CR>',
          delete_char = '<BS>',
          delete_char_right = '<Del>',
          delete_left = '<C-u>',
          delete_word = '<C-w>',
          mark     = '<C-x>',
          mark_all = '<C-a>',
          move_down = '<C-n>',
          move_start = '<C-g>',
          move_up = '<C-p>',
          paste = '<C-r>',
          refine = '<C-Space>',
          scroll_down = '<C-f>',
          scroll_left = '<C-h>',
          scroll_right = '<C-l>',
          scroll_up = '<C-b>',
          stop = '<Esc>',
          toggle_info = '<S-Tab>',
          toggle_preview = '<Tab>',
        },
      })

      -- Setup pick keymaps (replacing telescope/fzf keymaps)
      vim.keymap.set('n', '<leader><leader>', function() require('mini.pick').builtin.files() end, { desc = '[ ] Search Files' })
      vim.keymap.set('n', '<leader>ff', function() require('mini.pick').builtin.files() end, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fr', function() require('mini.pick').builtin.resume() end, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>tg', function() require('mini.pick').builtin.grep_live() end, { desc = '[T]elescope [G]rep' })
      vim.keymap.set('n', '<leader>fl', function() require('mini.pick').builtin.buffers() end, { desc = '[F]ind buffer [L]ist' })
      vim.keymap.set('n', '<leader>bl', function() require('mini.pick').builtin.buffers() end, { desc = '[B]uffer [L]ist' })
      vim.keymap.set('n', '<leader>th', function() require('mini.pick').builtin.help() end, { desc = '[T]elescope [H]elp' })
      vim.keymap.set('n', '<leader>tk', function() require('mini.pick').builtin.keymaps() end, { desc = '[T]elescope [K]eymaps' })
      vim.keymap.set('n', '<leader>tw', function() require('mini.pick').builtin.grep({pattern = vim.fn.expand('<cword>')}) end, { desc = '[T]elescope current [W]ord' })
      vim.keymap.set('n', '<leader>td', function() require('mini.pick').builtin.diagnostic() end, { desc = '[T]elescope [D]iagnostics' })

      -- Replaces: oil.nvim  
      -- File explorer
      require('mini.files').setup({
        content = { prefix = require('mini.files').gen_prefix.expanding },
        mappings = {
          close       = 'q',
          go_in       = 'l',
          go_in_plus  = 'L', 
          go_out      = 'h',
          go_out_plus = 'H',
          reset       = '<BS>',
          reveal_cwd  = '@',
          show_help   = 'g?',
          synchronize = '=',
          trim_left   = '<',
          trim_right  = '>',
        },
        windows = {
          preview = true,
          width_focus = 30,
          width_nofocus = 15,
          width_preview = 25,
        },
      })

      -- Setup file explorer keymaps (replacing oil keymaps)
      vim.keymap.set('n', '-', function() require('mini.files').open() end, { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>_', function() require('mini.files').open() end, { desc = 'Open parent directory' })

      -- Replaces: which-key.nvim
      -- Show key clues for mappings
      require('mini.clue').setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },
          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },
          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },
          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },
          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },
          -- Window commands
          { mode = 'n', keys = '<C-w>' },
          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },
        clues = {
          -- Enhance this by adding descriptions for `<Leader>` mapping groups
          require('mini.clue').gen_clues.builtin_completion(),
          require('mini.clue').gen_clues.g(),
          require('mini.clue').gen_clues.marks(),
          require('mini.clue').gen_clues.registers(),
          require('mini.clue').gen_clues.windows(),
          require('mini.clue').gen_clues.z(),
          
          -- Custom clues for leader groups
          { mode = 'n', keys = '<leader>f', desc = '+Find' },
          { mode = 'n', keys = '<leader>b', desc = '+Buffers' },
          { mode = 'n', keys = '<leader>c', desc = '+Code' },
          { mode = 'n', keys = '<leader>r', desc = '+Rename' },
          { mode = 'n', keys = '<leader>t', desc = '+Telescope' },
          { mode = 'n', keys = '<leader>h', desc = '+Git Hunk' },
          { mode = 'n', keys = '<leader>l', desc = '+LSPs' },
          { mode = 'n', keys = '<leader>j', desc = '+Jarpoon' },
          { mode = 'n', keys = '<leader>s', desc = '+Search' },
          { mode = 'n', keys = '<leader>g', desc = '+Git' },
        },
      })

      -- Replaces: todo-comments.nvim and nvim-colorizer
      -- Highlight patterns like TODO, FIXME, colors, etc.
      require('mini.hipatterns').setup({
        highlighters = {
          -- Highlight TODO comments
          todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsNote' },
          fran = { pattern = '%f[%w]()FRAN()%f[%W]', group = 'MiniHipatternsNote' },
          here = { pattern = '%f[%w]()HERE()%f[%W]', group = 'MiniHipatternsNote' },
          fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
          hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
          note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
          
          -- Highlight hex colors
          hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
        },
      })

      -- Replaces: guess-indent.nvim (visualization)
      -- Indent scope visualization  
      require('mini.indentscope').setup({
        draw = {
          delay = 100,
          animation = require('mini.indentscope').gen_animation.none(),
        },
        mappings = {
          object_scope = 'ii',
          object_scope_with_border = 'ai',
          goto_top = '[i',
          goto_bottom = ']i',
        },
        options = {
          border = 'both',
          indent_at_cursor = true,
          try_as_border = true,
        },
        symbol = '│',
      })

      -- Add commenting functionality
      require('mini.comment').setup()

      -- Buffer remove functionality for better buffer management
      require('mini.bufremove').setup()
      vim.keymap.set('n', '<leader>bd', function() require('mini.bufremove').delete() end, { desc = '[B]uffer [D]elete' })

      -- Git functionality
      require('mini.git').setup()

      -- Notifications
      require('mini.notify').setup()

      -- Icons (already used by oil, extending usage)
      require('mini.icons').setup()

      -- Quick navigation with f/F/t/T on steroids
      require('mini.jump2d').setup({
        mappings = {
          start_jumping = '<CR>',
        },
      })

      -- Additional keymaps to maintain compatibility
      -- Mini.pick additional keymaps
      vim.keymap.set('n', '<leader>fs', function() 
        require('mini.pick').builtin.grep_live({ pattern = vim.fn.expand('<cword>') })
      end, { desc = '[F]ind [S]ymbol under cursor' })
      
      vim.keymap.set('n', '<leader>tt', function()
        require('mini.pick').start({
          source = {
            items = vim.fn.getcompletion('', 'color'),
            name = 'Colorschemes',
            choose = function(item) 
              if item then vim.cmd('colorscheme ' .. item) end 
            end,
          }
        })
      end, { desc = '[T]heme selection' })

      vim.keymap.set('n', '<leader>fj', function()
        require('mini.pick').start({
          source = {
            items = {'files', 'buffers', 'grep_live', 'help', 'resume'},
            name = 'Mini.pick builtin',
            choose = function(item)
              if item then require('mini.pick').builtin[item]() end
            end,
          }
        })
      end, { desc = '[F]ind builtin [J]options' })

      -- Replace todo search functionality
      vim.keymap.set('n', '<leader>to', function()
        require('mini.pick').builtin.grep_live({ pattern = 'TODO|FIXME|HACK|NOTE|FRAN|HERE' })
      end, { desc = '[T]odo search' })
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'query', 'vim', 'vimdoc', 'hyprlang' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby', 'php' },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          scope_incremental = '<CR>',
          node_incremental = '<TAB>',
          node_decremental = '<S-TAB>',
        },
      },
      indent = { enable = true, disable = { 'ruby', 'php' } },
      vim.filetype.add {
        pattern = { ['.*/hypr/.*%.conf'] = 'hyprlang', ['.env*'] = 'cfg', ['Tiltfile'] = 'starlark' },
      },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs', -- replaced by mini.pairs
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- replaced by mini.diff

  -- NOTE: The import below can automatically add my own plugins, configuration, etc from `lua/<user>/plugins/*.lua`
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  --
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  { import = 'demaster.plugins' },
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.cmd.colorscheme 'rose-pine'
vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]
--
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
