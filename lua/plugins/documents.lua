return {
  {
    "mpas/marp-nvim",
    cmd = { "MarpStart", "MarpStop", "MarpStatus", "MarpToggle" },
    config = function()
      require("marp").setup()
    end,
  },
  {
    "arminveres/md-pdf.nvim",
    branch = "main", -- you can assume that main is somewhat stable until releases will be made
    lazy = true,
    keys = {
      {
        "<leader>o,",
        function()
          require("md-pdf").convert_md_to_pdf()
        end,
        desc = "Export Markdown to PDF",
      },
    },
    main = "md-pdf",
    opts = {
      toc = false,
      pandoc_user_args = {
        "--pdf-engine=lualatex",
      },
    },
  },
  {
    "obsidian-nvim/obsidian.nvim",
    lazy = true,
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre " .. vim.fn.expand("~") .. "/Notes/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Notes/*.md",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    main = "obsidian",
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "notes",
          path = "~/Notes/",
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "markdown.mdx" },
    opts = {
      -- Let Neovim wrap table rows without adding virtual cell padding.
      pipe_table = { cell = "raw", wrap = false },
    },
  },
}
