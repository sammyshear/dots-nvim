local o = vim.opt

o.number = true -- line numbers
o.relativenumber = true -- for hybrid line numbers
o.mouse = "a" -- allow mouse (helpful early on)
o.clipboard = "unnamedplus" -- sync with system clipboard
o.ignorecase = true -- case-insensitive search...
o.smartcase = true -- ...unless you type capitals
o.termguicolors = true -- 24-bit color support
o.expandtab = true -- spaces instead of tabs
o.shiftwidth = 2 -- fallback indent (guess-indent overrides per-file)
o.tabstop = 2
o.signcolumn = "yes" -- always show gutter
o.splitright = true -- vertical splits go right
o.splitbelow = true -- horizontal splits go below
o.cursorline = true -- highlight current line
o.scrolloff = 4 -- keep some context around cursor
o.confirm = true -- dialog on unsaved changes instead of error
o.inccommand = "split" -- live preview of :s substitutions
o.updatetime = 250 -- faster LSP diagnostics
o.timeoutlen = 300 -- faster which-key popup
o.showmode = false -- already shown in the statusline
o.breakindent = true -- wrapped lines keep their indentation
o.wrap = false -- no line wrapping in code

-- Persistent undo history — files accumulate in ~/.local/state/nvim/undo/
-- Clean up periodically:  rm -rf ~/.local/state/nvim/undo/
o.undofile = true
o.completeopt = "menu,menuone,noselect"
o.list = true -- show invisible characters
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.autoformat = true
