local parsers = {
  "lua",
  "bash",
  "vim",
  "vimdoc",
  "git_config",
  "gitcommit",
  "git_rebase",
  "gitignore",
  "gitattributes",
  "json",
  "yaml",
  "toml",
  "markdown",
  "markdown_inline",
  "bibtex",
  "c",
  "cpp",
  "cmake",
  "dockerfile",
  "go",
  "gomod",
  "gowork",
  "gosum",
  "gotmpl",
  "templ",
  "nix",
  "python",
  "rust",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      vim.cmd.TSUpdate()
    end,
    config = function()
      local installing = false
      local function install_missing()
        if installing or vim.fn.executable("tree-sitter") ~= 1 then
          return
        end

        local missing = vim.tbl_filter(function(lang)
          return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
        end, parsers)
        if #missing == 0 then
          return
        end

        installing = true
        require("nvim-treesitter").install(missing):await(vim.schedule_wrap(function(err)
          installing = false
          if err then
            vim.notify("Treesitter parser installation failed: " .. tostring(err), vim.log.levels.ERROR)
            return
          end

          -- Buffers opened before installation finished have already fired FileType.
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(buf) then
              local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
              if vim.tbl_contains(missing, lang) then
                vim.api.nvim_exec_autocmds("FileType", { group = "starter-treesitter", buffer = buf })
              end
            end
          end
        end))
      end

      vim.api.nvim_create_user_command("InstallVnextParsers", install_missing, {
        desc = "Install missing vnext Treesitter parsers",
      })
      vim.schedule(install_missing)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    keys = { { "<leader>ut", "<cmd>TSContext toggle<cr>", desc = "Toggle Treesitter context" } },
    opts = { mode = "cursor", max_lines = 3 },
  },
}
