local p = vim.pack

p.add({
  { src = "https://github.com/zuqini/zpack.nvim", name = "zpack.nvim" },
}, { confirm = false })

require("zpack").setup({
  defaults = {
    confirm = false, -- set to false to skip vim.pack install prompts (default: true)
    cond = nil, -- global condition for all plugins, e.g. not vim.g.is_vscode (default: nil)
    lazy = false, -- make every spec lazy-load by default unless it sets lazy=false (lazy.nvim parity, default: false)
    version = nil, -- default version applied when a spec has no version/sem_version/branch/tag/commit (lazy.nvim parity, default: nil)
  },
  performance = {
    vim_loader = true, -- enables vim.loader for faster startup (default: true)
  },
  cmd_name = "Z", -- name of the user command (default: 'ZPack'). Use as: :ZPack update, :ZPack clean, etc.
})
