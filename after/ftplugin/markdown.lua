vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.breakindent = true
vim.opt_local.textwidth = 0

vim.keymap.set("n", "I", function()
  return vim.wo.wrap and "g^i" or "I"
end, { buffer = true, expr = true, desc = "Insert at start of screen line" })
vim.keymap.set("n", "A", function()
  return vim.wo.wrap and "g$a" or "A"
end, { buffer = true, expr = true, desc = "Append at end of screen line" })

local undo = table.concat({
  "setlocal wrap< linebreak< breakindent< textwidth<",
  "execute 'silent! nunmap <buffer> I'",
  "execute 'silent! nunmap <buffer> A'",
}, " | ")
vim.b.undo_ftplugin = vim.b.undo_ftplugin and (vim.b.undo_ftplugin .. " | " .. undo) or undo
