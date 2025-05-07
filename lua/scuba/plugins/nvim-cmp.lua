return {
  "hrsh7th/nvim-cmp",
  -- event = "InsertEnter", -- This is usually fine; config runs after plugin loads.
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    "hrsh7th/cmp-cmdline", -- source for command line (you have this!)
    "dmitmel/cmp-cmdline-history", -- RECOMMENDED: source for command line history
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
      dependencies = { "rafamadriz/friendly-snippets" }, -- Group friendly-snippets here
    },
    "saadparwaiz1/cmp_luasnip", -- for autocompletion with LuaSnip
    -- "rafamadriz/friendly-snippets", -- Moved as a dependency of LuaSnip for clarity
    "onsails/lspkind.nvim", -- vs-code like pictograms
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Confirm with current selection (more common)

        -- Add Tab/S-Tab for cycling through insert mode completions
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback() -- This will fallback to normal tab behavior (like indent)
          end
        end, { "i", "s" }), -- "i" for insert mode, "s" for select mode (visual)
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      -- sources for autocompletion in INSERT MODE
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        -- { name = "cmdline" }, -- Generally not needed here if setting up via cmp.setup.cmdline
      }),
      formatting = {
        format = lspkind.cmp_format({
          maxwidth = 50,
          ellipsis_char = "...",
          mode = "symbol_text", -- Show symbol and text
        }),
      },
    })

    -- Setup command line completion for ':'
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(), -- This preset includes Tab/S-Tab/Enter etc. for cmdline
      sources = cmp.config.sources({
        { name = "path" }, -- Source for file system paths (e.g., :e /pa<Tab>)
      }, {
        { name = "cmdline" }, -- Source for Neovim commands (e.g., :Colo<Tab>)
        { name = "cmdline_history" }, -- RECOMMENDED: Source for your command history
      }),
    })

    -- Setup command line completion for search '/' and '?'
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" }, -- Source for words in current buffer (good for search)
        -- You could add other search-specific sources here if needed
      },
    })
  end,
}
