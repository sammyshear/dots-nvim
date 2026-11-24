-- 0 ─ Loader (faster startup) ────────────────────────────────────────────────
vim.loader.enable()

-- 1 ─ Leader keys ────────────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config")

vim.api.nvim_create_user_command("LspInfo", function()
  Snacks.picker.lsp_config()
end, { desc = "Inspect language server configurations and clients" })
