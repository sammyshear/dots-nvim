-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.api.nvim_create_autocmd("FileType", {
  pattern = "norg",
  callback = function()
    vim.keymap.set("n", "<Leader>o<", "<Plug>(neorg.promo.demote.range)")
    vim.keymap.set("n", "<Leader>ox", "<Plug>(neorg.qol.todo-items.todo.task-cycle)")
    vim.keymap.set("n", "<Leader>o>", "<Plug>(neorg.promo.promote.range)")
    vim.keymap.set("n", "g$", "<cmd>Neorg toc<CR>")
  end,
})
