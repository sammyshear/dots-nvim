return {
  { "wakatime/vim-wakatime", lazy = false },
  {
    "sammyshear/sefaria.nvim",
    name = "sefaria.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    opts = {},
    version = "*",
  },
  { "dopefishh/vim-praat" },
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- 👇 in this section, choose your own keymappings!
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        -- Open in the current working directory
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
  {
    {
      "mfussenegger/nvim-lint",
      opts = {
        linters = {
          ["markdownlint-cli2"] = {
            args = { "--config", vim.fn.expand("~") .. "/markdownlint.yaml", "--" },
          },
        },
      },
    },
  },
  {
    "mpas/marp-nvim",
    cmd = "MarpStart",
    config = function()
      require("marp").setup()
    end,
  },
  {
    "lambdalisue/vim-suda",
  },
  {
    "klen/nvim-config-local",
    config = function()
      require("config-local").setup()
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        templ = { "templ" },
        markdown = { "mdsf", "mdslw", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "sindrets/diffview.nvim",
      "m00qek/baleia.nvim",
      "folke/snacks.nvim",
    },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
