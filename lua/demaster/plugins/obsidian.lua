return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
  },
  opts = {
    disable_frontmatter = true,
    templates = {
        folder = "5 Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
    },
    workspaces = {
      {
        name = "personal",
        path = "~/Notes/Personal",
      },
      {
        name = "new-personal",
        path = "~/Notes/twentieth-second-brain/source/content",
      },
      {
        name = "work",
        path = "~/Notes/Work",
      },
    },
  },
}
