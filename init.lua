-- 0 ─ Loader (faster startup) ────────────────────────────────────────────────
vim.loader.enable()

-- 1 ─ Leader keys ────────────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config")
