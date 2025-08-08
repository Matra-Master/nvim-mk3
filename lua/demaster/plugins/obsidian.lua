return {
  'epwalsh/obsidian.nvim',
  version = '*', -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = 'markdown',
  dependencies = {
    -- Required.
    'nvim-lua/plenary.nvim',
  },
  opts = {
    disable_frontmatter = true,
    templates = {
      folder = '5 Templates',
      date_format = '%Y%m%d',
      time_format = '%H%M',
    },
    workspaces = {
      {
        name = 'personal',
        path = '~/Notes/Personal',
      },
      {
        name = 'new-personal',
        path = '~/Notes/twentieth-second-brain/source/content',
      },
      {
        name = 'work',
        path = '~/Notes/Work',
      },
    },
    daily_notes = {
      -- Optional, if you keep daily notes in a separate directory.
      folder = '6 Dailies',
      -- Optional, if you want to change the date format for the ID of daily notes.
      date_format = '%Y-%m-%d',
      -- Optional, if you want to change the date format of the default alias of daily notes.
      alias_format = '%B %-d, %Y',
      -- Optional, default tags to add to each new daily note created.
      default_tags = { 'daily-notes' },
      -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
      template = nil,
    },
  },
}
