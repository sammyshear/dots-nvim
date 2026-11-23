local zero_keyword_lsp = {
  badness = true,
}

return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      {
        "saghen/blink.compat",
        optional = true,
        opts = {},
      },
      {
        "saghen/blink.lib",
      },
    },
    build = function()
      require("blink.cmp").build():pwait()
    end,
    opts = {
      fuzzy = { implementation = "prefer_rust_with_warning" },
      keymap = {
        preset = "enter",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            min_keyword_length = function(ctx)
              if ctx.trigger.kind == "manual" then
                return 0
              end
              -- Blink combines all attached servers into one LSP source.
              for _, client in ipairs(vim.lsp.get_clients({ bufnr = ctx.bufnr, method = "textDocument/completion" })) do
                if zero_keyword_lsp[client.name] then
                  return 0
                end
              end
              return 2
            end,
            score_offset = 0,
          },
          path = {
            min_keyword_length = 0,
          },
          snippets = {
            min_keyword_length = 2,
            should_show_items = function(ctx)
              return ctx.trigger.initial_kind ~= "trigger_character" and not require("blink.cmp").snippet_active()
            end,
          },
          buffer = {
            min_keyword_length = 5,
            max_items = 5,
          },
        },
      },
      cmdline = {
        keymap = {
          preset = "cmdline",
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = { auto_show = true },
        },
      },
      completion = {
        documentation = {
          auto_show = false,
          treesitter_highlighting = true,
          window = { border = "rounded" },
        },
        list = {
          selection = { preselect = false, auto_insert = false },
        },
        trigger = {
          show_on_insert_on_trigger_character = false,
          show_on_accept_on_trigger_character = false,
        },
        menu = {
          border = "rounded",
          draw = {
            columns = { { "label", "label_description", gap = 1 }, { "kind_icon" } },
          },
        },
        accept = { auto_brackets = { enabled = true } },
      },
    },
    opts_extend = {
      "sources.default",
      "sources.compat",
    },
    config = function(_, opts)
      -- setup compat sources and provider
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          require("blink.cmp.types").CompletionItemKind[provider.kind] = provider.kind
        end
      end

      local blink = require("blink.cmp")
      blink.setup(opts)

      local trigger = require("blink.cmp.completion.trigger")
      local context = require("blink.cmp.completion.trigger.context")
      local lsp_source = require("blink.cmp.sources.lsp")
      local utils = require("blink.cmp.lib.utils")
      local group = vim.api.nvim_create_augroup("BlinkCursorCompletion", { clear = true })
      local previous
      vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
        group = group,
        desc = "Request Blink completions after moving the insert-mode cursor",
        callback = function(event)
          local win = vim.api.nvim_get_current_win()
          local cursor = vim.api.nvim_win_get_cursor(win)
          local row, col = cursor[1], cursor[2]
          local tick = vim.api.nvim_buf_get_changedtick(event.buf)
          local moved = event.event ~= "InsertEnter"
            and previous
            and previous.buf == event.buf
            and previous.win == win
            and previous.tick == tick
            and (previous.row ~= row or previous.col ~= col)
          previous = { buf = event.buf, win = win, row = row, col = col, tick = tick }

          if not moved or trigger.context or trigger.buffer_events:hide_in_snippet() then
            return
          end

          if context.get_bounds("full").length == 0 then
            local char = col > 0 and utils.get_char_at_cursor()
            if not char or not vim.tbl_contains(lsp_source:get_trigger_characters(), char) then
              return
            end
          end

          -- Use Blink's automatic request path so provider keyword limits still apply.
          trigger.show({ trigger_kind = "keyword" })
        end,
      })
    end,
  },
}
