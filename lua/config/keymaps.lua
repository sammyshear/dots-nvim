local km = vim.keymap

km.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
km.set("n", "<leader>cm", "<cmd>Mason<CR>", { desc = "[C]heck [M]ason (install LSPs)" })
km.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
km.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
km.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
km.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
km.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })
km.set("v", "<", "<gv")
km.set("v", ">", ">gv")

km.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
km.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Snacks
km.set("n", "<leader>sf", function()
  Snacks.picker.files()
end, { desc = "[S]earch [F]iles" })
km.set("n", "<leader>sh", function()
  Snacks.picker.help()
end, { desc = "[S]earch [H]elp" })
km.set("n", "<leader>sk", function()
  Snacks.picker.keymaps()
end, { desc = "[S]earch [K]eymaps" })
km.set("n", "<leader>s.", function()
  Snacks.picker.recent()
end, { desc = '[S]earch recent files ("." for repeat)' })
km.set("n", "<leader>tt", function()
  Snacks.terminal()
end, { desc = "[T]erminal [T]oggle" })

local function project_root()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = vim.bo.buftype == "" and file ~= "" and vim.fs.dirname(file) or vim.fn.getcwd()
  local root
  local function consider(path)
    if type(path) ~= "string" then
      return
    end
    path = vim.fs.normalize(path)
    local prefix = path == "/" and path or path .. "/"
    if (dir == path or vim.startswith(dir, prefix)) and (not root or #path > #root) then
      root = path
    end
  end
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
    for _, workspace in ipairs(client.workspace_folders or {}) do
      consider(vim.uri_to_fname(workspace.uri))
    end
    consider(client.root_dir)
  end
  return root or vim.fs.root(dir, ".git") or vim.fn.getcwd()
end

local function picker(keys, source, desc, project, mode)
  km.set(mode or "n", keys, function()
    Snacks.picker[source](project and { cwd = project_root() } or {})
  end, { desc = desc })
end

picker("<leader><space>", "files", "Find files (project)", true)
picker("<leader>ff", "files", "Find files (project)", true)
picker("<leader>fF", "files", "Find files (cwd)")
km.set("n", "<leader>fh", function()
  Snacks.picker.files({ hidden = true, ignored = false, exclude = { ".git" } })
end, { desc = "Find files including hidden (cwd)" })
picker("<leader>/", "grep", "Grep (project)", true)
picker("<leader>sg", "grep", "Grep (project)", true)
picker("<leader>sG", "grep", "Grep (cwd)")
picker("<leader>sw", "grep_word", "Grep word or selection (project)", true, { "n", "x" })
picker("<leader>sW", "grep_word", "Grep word or selection (cwd)", false, { "n", "x" })
picker("<leader>,", "buffers", "Buffers")
picker("<leader>fb", "buffers", "Buffers")
picker("<leader>fr", "recent", "Recent files")
picker("<leader>:", "command_history", "Command history")
picker("<leader>sd", "diagnostics", "Diagnostics")
picker("<leader>sD", "diagnostics_buffer", "Buffer diagnostics")
picker("<leader>gs", "git_status", "Git status")
km.set("n", "<leader>gg", function()
  Snacks.lazygit({ cwd = Snacks.git.get_root() or vim.fn.getcwd() })
end, { desc = "LazyGit (repository)" })
km.set("n", "<leader>gG", function()
  Snacks.lazygit()
end, { desc = "LazyGit (cwd)" })
km.set("n", "<leader>gb", function()
  Snacks.git.blame_line()
end, { desc = "Git blame line" })
km.set("n", "<leader>cR", function()
  Snacks.rename.rename_file()
end, { desc = "Rename file" })
km.set("n", "<leader>.", function()
  vim.ui.input({ prompt = "Scratch filetype (default: markdown)", completion = "filetype" }, function(filetype)
    if filetype == nil then
      return
    end
    filetype = vim.trim(filetype)
    if filetype ~= "" and not filetype:match("^[%w_.-]+$") then
      vim.notify("Invalid scratch filetype", vim.log.levels.WARN)
      return
    end
    Snacks.scratch({ ft = filetype == "" and "markdown" or filetype })
  end)
end, { desc = "Open scratch buffer by filetype" })
km.set("n", "<leader>S", function()
  Snacks.scratch.select()
end, { desc = "Pick a saved scratch buffer" })
km.set("n", "<leader>bb", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })
km.set("n", "<leader>`", "<cmd>buffer #<cr>", { desc = "Alternate buffer" })
km.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
km.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
km.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
km.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
km.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })
km.set("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete other buffers" })
local function open_explorer(cwd)
  local inside_git = vim.fn.system({ "git", "-C", cwd, "rev-parse", "--is-inside-work-tree" })
  Snacks.explorer({
    cwd = cwd,
    hidden = vim.v.shell_error == 0 and vim.trim(inside_git) == "true",
    ignored = false,
    exclude = { ".git" },
  })
end

for _, suffix in ipairs({ "e", "fe" }) do
  km.set("n", "<leader>" .. suffix, function()
    open_explorer(project_root())
  end, { desc = "Explorer (project)" })
end
for _, suffix in ipairs({ "E", "fE" }) do
  km.set("n", "<leader>" .. suffix, function()
    open_explorer(vim.fn.getcwd())
  end, { desc = "Explorer (cwd)" })
end
km.set("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = project_root() })
end, { desc = "Terminal (project)" })
km.set("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })
for _, key in ipairs({ "<c-/>", "<c-_>" }) do
  km.set({ "n", "t" }, key, function()
    Snacks.terminal.focus(nil, { cwd = project_root() })
  end, { desc = "Terminal (project)" })
end
km.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
for _, item in ipairs({ { "d" }, { "e", vim.diagnostic.severity.ERROR }, { "w", vim.diagnostic.severity.WARN } }) do
  for key, count in pairs({ ["["] = -1, ["]"] = 1 }) do
    km.set(
      "n",
      key .. item[1],
      function()
        vim.diagnostic.jump({ count = count, severity = item[2], float = true })
      end,
      { desc = (count > 0 and "Next " or "Previous ") .. ({ d = "diagnostic", e = "error", w = "warning" })[item[1]] }
    )
  end
end
km.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
km.set("n", "<leader>-", "<C-w>s", { desc = "Split below" })
km.set("n", "<leader>|", "<C-w>v", { desc = "Split right" })
km.set("n", "<leader>wd", "<C-w>c", { desc = "Close window" })
km.set("n", "<leader>ll", "<cmd>ZShow<cr>", { desc = "Show plugins" })
km.set("n", "<leader>lu", "<cmd>Z update<cr>", { desc = "Update plugins" })
km.set("n", "<leader>ls", "<cmd>Z sync<cr>", { desc = "Sync plugins" })
km.set("n", "<leader>lr", "<cmd>Z restore<cr>", { desc = "Restore plugins from lockfile" })
km.set("n", "<leader>lc", "<cmd>Z clean<cr>", { desc = "Clean unused plugins" })
km.set("n", "<leader>lb", ":Z build ", { desc = "Build a plugin" })
km.set("n", "<leader>la", ":Z load ", { desc = "Load a plugin" })
km.set("n", "<leader>lR", ":Z reload ", { desc = "Reload a plugin" })
km.set("n", "<leader>ld", ":Z delete ", { desc = "Delete a plugin" })

km.set("n", "<leader>nn", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })
km.set("n", "<leader>nd", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
