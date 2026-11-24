local api = vim.api

api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= "install" and kind ~= "update" then
      return
    end
    if name == "LuaSnip" and vim.fn.has("win32") ~= 1 and vim.fn.executable("make") == 1 then
      vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path }):wait()
    end
  end,
})

api.nvim_create_autocmd("TextYankPost", {
  desc = "Flash yanked text",
  group = vim.api.nvim_create_augroup("starter-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("starter-lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf, nowait = true, desc = "LSP: References" })
    map("gI", vim.lsp.buf.implementation, "Implementation")
    map("gy", vim.lsp.buf.type_definition, "Type definition")
    map("gD", vim.lsp.buf.declaration, "Declaration")
    map("gK", vim.lsp.buf.signature_help, "Signature help")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame Symbol")
    vim.keymap.set(
      { "n", "x" },
      "<leader>ca",
      vim.lsp.buf.code_action,
      { buffer = event.buf, desc = "LSP: Code action" }
    )

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method("textDocument/rename", event.buf) then
      vim.keymap.set("n", "<leader>cr", function()
        if #vim.lsp.get_clients({ bufnr = event.buf, method = "textDocument/rename" }) == 0 then
          return ""
        end
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { buffer = event.buf, expr = true, desc = "LSP: Inline rename" })
    end

    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
      map("[[", function()
        Snacks.words.jump(-vim.v.count1)
      end, "Previous reference")
      map("]]", function()
        Snacks.words.jump(vim.v.count1)
      end, "Next reference")
    end
  end,
})

api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("starter-treesitter", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or lang == "latex" then
      return
    end

    local has_parser = vim.treesitter.language.add(lang)
    if not has_parser then
      return
    end

    pcall(vim.treesitter.start, args.buf, lang)
  end,
})

api.nvim_create_autocmd("FileType", {
  pattern = "tex",
  callback = function(event)
    vim.keymap.set(
      "n",
      "<leader>K",
      "<Plug>(vimtex-doc-package)",
      { buffer = event.buf, desc = "VimTeX package documentation" }
    )
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gotmpl",
  callback = function(event)
    vim.b[event.buf].snacks_words = false
  end,
})

vim.filetype.add({ extension = { mdx = "markdown.mdx" } })
vim.treesitter.language.register("markdown", "markdown.mdx")
