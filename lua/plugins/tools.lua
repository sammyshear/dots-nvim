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
            args = { "--config", vim.fn.expand("~") .. "/.config/nvim/markdownlint.json", "--" },
          },
        },
        linters_by_ft = {
          markdown = { "markdownlint-cli2" },
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
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          args = { "--config", vim.fn.expand("~") .. "/.config/nvim/markdownlint.json", "--" },
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
