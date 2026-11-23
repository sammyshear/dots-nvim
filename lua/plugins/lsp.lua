return {
  {
    "lervag/vimtex",
    lazy = false, -- lazy-loading will disable inverse search
    init = function()
      vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
      vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"
      vim.g.vimtex_compiler_latexmk = {
        build_dir = ".out",
        options = {
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-interaction=nonstopmode",
          "-synctex=1",
        },
      }
    end,
    keys = {
      { "<localLeader>l", "", desc = "+vimtex", ft = "tex" },
    },
  },
  { "flammie/vim-finitestatemorphology" },
  { "dopefishh/vim-praat" },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      {
        "mason-org/mason.nvim",
        config = function()
          require("mason").setup()
          require("config.mason_tools")()
        end,
      },
      { "neovim/nvim-lspconfig" },
      { "saghen/blink.cmp" },
    },
    config = function()
      local servers = {
        "lua_ls",
        "bashls",
        "jsonls",
        "yamlls",
        "taplo",
        "marksman",
        "clangd",
        "neocmake",
        "dockerls",
        "docker_compose_language_service",
        "gopls",
        "nil_ls",
        "pyright",
        "ruff",
      }
      -- Advertise Blink capabilities before Mason enables servers.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })
      vim.lsp.config("ruff", {
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      })
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = servers,
      })
      vim.lsp.config("badness", {
        cmd = { "badness", "lsp" },
        filetypes = { "tex", "latex", "plaintex", "bib" },
        root_markers = { "badness.toml", ".git" },
      })
      vim.lsp.enable("badness")
      vim.lsp.enable("rust_analyzer")
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
  },
  {
    "linux-cultist/venv-selector.nvim",
    ft = "python",
    cmd = "VenvSelect",
    keys = { { "<leader>cv", "<cmd>VenvSelect<cr>", ft = "python", desc = "Select VirtualEnv" } },
    opts = { options = { picker = "snacks", notify_user_on_venv_activation = true, override_notify = false } },
  },
}
