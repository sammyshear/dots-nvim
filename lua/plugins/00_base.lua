return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "mocha",
      transparent_background = true,
      term_colors = true,
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      auto_integrations = true,
    },
  },
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          function()
            local cwd = vim.fn.getcwd()
            local name = vim.fs.basename(cwd)
            return { header = "Project: " .. (name ~= "" and name or cwd), padding = 2 }
          end,
          { section = "keys", padding = 1 },
          { pane = 2, section = "recent_files", title = "Recent files", limit = 5, padding = 1 },
          {
            pane = 2,
            section = "terminal",
            title = "Git status",
            cmd = "git status --short --branch",
            height = 5,
            ttl = 15,
            enabled = function()
              return vim.fn.system({ "git", "rev-parse", "--is-inside-work-tree" }):match("^true") ~= nil
            end,
          },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      notifier = { enabled = true },
      words = { enabled = true },
      terminal = { enabled = true },
      picker = {
        matcher = {
          fuzzy = true,
          smartcase = true,
          filename_bonus = true,
        },
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
  },
  {
    "NMAC427/guess-indent.nvim",
  },
  {
    "sairyy/zshow.nvim",
    lazy = false, -- no need for lazy loading
    init = function()
      vim.g.zshow_opts = {}
    end,
  },
}
