local packages = {
  -- Formatters (Ruff and Taplo are already installed by mason-lspconfig).
  "badness",
  "clang-format",
  "cmakelang",
  "dockerfmt",
  "gofumpt",
  "goimports",
  "isort",
  "nixfmt",
  "oxfmt",
  "shfmt",
  "stylua",
  "terraform",
  "yamlfmt",

  -- Linters.
  "cmakelint",
  "golangci-lint",
  "hadolint",
  "markdownlint-cli2",
  "selene",
  "shellcheck",
  "statix",

  -- Native LSP and parser tooling.
  "rust-analyzer",
  "tree-sitter-cli",
}

local function ensure_installed()
  local registry = require("mason-registry")
  local missing = vim.tbl_filter(function(name)
    return not registry.is_installed(name)
  end, packages)
  if #missing == 0 then
    return
  end

  registry.refresh(vim.schedule_wrap(function()
    local unavailable = {}
    for _, name in ipairs(missing) do
      if registry.has_package(name) then
        local package = registry.get_package(name)
        if not package:is_installed() and not package:is_installing() and not package:is_uninstalling() then
          package:install(
            {},
            vim.schedule_wrap(function(success)
              if success and name == "tree-sitter-cli" and vim.fn.exists(":InstallVnextParsers") == 2 then
                vim.cmd.InstallVnextParsers()
              end
            end)
          )
        end
      else
        unavailable[#unavailable + 1] = name
      end
    end
    if #unavailable > 0 then
      vim.notify("Mason packages unavailable: " .. table.concat(unavailable, ", "), vim.log.levels.WARN)
    end
  end))
end

return ensure_installed
