return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        cmake = { "cmakelint" },
        dockerfile = { "hadolint" },
        go = { "golangcilint" },
        markdown = { "markdownlint-cli2" },
        ["markdown.mdx"] = { "markdownlint-cli2" },
        nix = { "statix" },
        sh = { "shellcheck" },
        lua = { "selene" },
      },
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft
      local markdownlint = lint.linters["markdownlint-cli2"]
      local args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.json" }
      vim.list_extend(args, markdownlint.args)
      markdownlint.args = args
      local lint_augroup = vim.api.nvim_create_augroup("linting", { clear = true })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile", "InsertLeave" },
    cmd = { "ConformInfo", "ToggleAutoformat" },
    opts = {
      format_on_save = function(bufnr)
        if not vim.g.autoformat then
          return
        end
        local lsp_fallback = vim.bo[bufnr].filetype == "typst" and true or false
        return { timeout_ms = 500, lsp_format = lsp_fallback and "fallback" or "never" }
      end,
      -- log_level = vim.log.levels.TRACE,
      formatters_by_ft = {
        dockerfile = { "dockerfmt" },
        go = { "goimports", "gofumpt" },
        javascript = { "oxfmt" },
        json = { "oxfmt" },
        lua = { "stylua" },
        markdown = { "oxfmt" },
        python = { "isort", "ruff_format" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        ["terraform-vars"] = { "terraform_fmt" },
        tex = { "badness" },
        bib = { "badness" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        cmake = { "cmake_format" },
        nix = { "nixfmt" },
        rust = { "rustfmt" },
        ["markdown.mdx"] = { "oxfmt" },
        toml = { "taplo" },
        xml = { "xmllint" },
        yaml = { "yamlfmt" },
      },
    },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        mode = { "n", "x" },
        desc = "Format",
      },
      { "<leader>uf", "<cmd>ToggleAutoformat<cr>", desc = "Toggle format on save" },
      { "<leader>tF", "<cmd>ToggleAutoformat<cr>", desc = "Toggle format on save" },
    },
    config = function(_, opts)
      opts.formatters = {
        badness = {
          command = "badness",
          args = { "format", "--stdin-filepath", "$FILENAME", "-" },
          cwd = function(_, ctx)
            return ctx.dirname
          end,
        },
      }
      local conform = require("conform")
      conform.setup(opts)
      conform.formatters.shfmt = {
        prepend_args = { "-i", "2" }, -- 2 spaces instead of tab
      }
      conform.formatters.stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" }, -- 2 spaces instead of tab
      }
      conform.formatters.yamlfmt = {
        prepend_args = {
          "-formatter",
          "indent=2",
          "-formatter",
          "include_document_start=true",
          "-formatter",
          "retain_line_breaks_single=true",
        },
      }
      vim.api.nvim_create_user_command("ToggleAutoformat", function()
        vim.notify("Toggling autoformat", vim.log.levels.INFO, { title = "conform.nvim", timeout = 2000 })
        vim.g.autoformat = vim.g.autoformat == false and true or false
      end, { desc = "Toggling autoformat" })
    end,
  },
  {
    "folke/flash.nvim",
    opts = {},
    keys = {
      -- stylua: ignore start
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash", },
      { "S",     mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
      -- Simulate nvim-treesitter incremental selection
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev"
            }
          })
        end,
        desc = "Treesitter Incremental Selection"
      },
      -- stylua: ignore end
    },
  },
  {
    "nvim-mini/mini.surround",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- Number of lines within which surrounding is searched
      n_lines = 50,
    },
  },
  {
    "gbprod/substitute.nvim",
    keys = {
      -- stylua: ignore start
      { "<leader>rp", function() require("substitute").operator() end, desc = "Substitute",                           noremap = true },
      { "<leader>rp", mode = "x",                                      function() require("substitute").visual() end, desc = "Substitute", noremap = true },
      -- stylua: ignore end
    },
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPre", -- needed to highlight keywords
    opts = {
      highlight = {
        multiline = false, -- I usually only want one line to be highlighted
      },
    },
    keys = {
      -- stylua: ignore start
      { "<leader>sT", function() Snacks.picker.todo_comments() end, desc = "Todo", },
      -- stylua: ignore end
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = {},
    keys = {
      -- stylua: ignore start
      { "<leader>rr", "<cmd>GrugFar<cr>",                                                                            desc = "Open" },
      { "<leader>rR", "<cmd>lua require('grug-far').open({ prefills = { paths = vim.fn.expand('%') } })<cr>",        desc = "Open (Limit to current file)" },
      { "<leader>rw", "<cmd>lua require('grug-far').open({ prefills = { search = vim.fn.expand('<cword>') } })<cr>", desc = "Search word under cursor", },
      { "<leader>rs", mode = "v",                                                                                    ":<C-u>lua require('grug-far').with_visual_selection({ prefills = { paths = vim.fn.expand('%') } })<cr>", desc = "Search selection", },
      -- stylua: ignore end
    },
  },
  {
    "nvim-mini/mini.align",
    keys = {
      { "ga", mode = { "v" }, desc = "Align" },
      { "gA", mode = { "v" }, desc = "Align with Preview" },
    },
    opts = {},
  },
  {
    "nvim-mini/mini.comment",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    opts = {},
  },
  {
    "nvim-mini/mini.ai",
    opts = {},
  },
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {},
  },
  {
    "stevearc/quicker.nvim",
    ft = "qf",
    opts = { constrain_cursor = false },
  },
}
