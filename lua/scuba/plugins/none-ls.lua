return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" }, -- Load when a buffer is read or a new one is created
  dependencies = {
    "nvim-lua/plenary.nvim", -- Often a utility dependency for various plugins
    "mason.nvim", -- Optional: if you use mason.nvim to manage linters/tools
  },
  config = function()
    local null_ls = require("null-ls")

    -- -- DEBUGGING: Print available builtins
    -- print(vim.inspect(null_ls.builtins.diagnostics))
    -- print(vim.inspect(null_ls.builtins.code_actions))
    -- print(vim.inspect(null_ls.builtins.formatting))
    -- -- END DEBUGGING

    local an_on_attach = function(client, bufnr)
      -- Standard on_attach for LSP-like capabilities
      -- This function will be called for each buffer none-ls attaches to.

      -- Enable completion triggered by <c-x><c-o>
      -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') -- Not typically needed for none-ls focus

      -- local map = function(keys, func, desc)
      --   vim.keymap.set("n", keys, func, { buffer = bufnr, noremap = true, silent = true, desc = desc })
      -- end
      --
      -- -- Keybindings for LSP features (will work with none-ls sources too)
      -- map("gd", vim.lsp.buf.definition, "LSP Go to Definition")
      -- map("gD", vim.lsp.buf.declaration, "LSP Go to Declaration")
      -- map("gr", vim.lsp.buf.references, "LSP Go to References")
      -- map("gI", vim.lsp.buf.implementation, "LSP Go to Implementation")
      -- map("K", vim.lsp.buf.hover, "LSP Hover")
      -- map("<C-k>", vim.lsp.buf.signature_help, "LSP Signature Help")
      -- map("<leader>ca", vim.lsp.buf.code_action, "LSP Code Action")
      -- map("<leader>rn", vim.lsp.buf.rename, "LSP Rename")
      -- map("<leader>fm", function() -- Your conform mapping is separate, this is just an example for context
      --   vim.lsp.buf.format({ async = true })
      -- end, "LSP Format Document")
      --
      -- -- Diagnostics navigation
      -- map("[d", vim.diagnostic.goto_prev, "Diagnostic Go to Previous")
      -- map("]d", vim.diagnostic.goto_next, "Diagnostic Go to Next")
      -- map("<leader>dl", vim.diagnostic.open_float, "Diagnostic Open Float")
      -- map("<leader>dq", vim.diagnostic.setqflist, "Diagnostic Quickfix List")

      -- Add more LSP-related mappings here if you like

      -- Highlight symbol under cursor (if supported by the source)
      if client.supports_method("textDocument/documentHighlight") then
        vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = "LspDocumentHighlight",
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
          buffer = bufnr,
          group = "LspDocumentHighlight",
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    null_ls.setup({
      -- You can add debug = true here for more verbose output from none-ls
      -- debug = true,
      sources = {
        -- ======== DIAGNOSTICS (LINTERS) ========
        null_ls.builtins.diagnostics.eslint_d, -- Or eslint, if you prefer. eslint_d is faster.
        -- null_ls.builtins.diagnostics.pylint,
        -- null_ls.builtins.diagnostics.flake8, -- Often used alongside pylint or as an alternative
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.luacheck,
        null_ls.builtins.diagnostics.stylelint, -- For CSS, SCSS, etc.
        null_ls.builtins.diagnostics.jsonlint, -- For JSON
        null_ls.builtins.diagnostics.yamllint, -- For YAML
        null_ls.builtins.diagnostics.markdownlint, -- For Markdown

        -- ======== CODE ACTIONS ========
        null_ls.builtins.code_actions.eslint_d, -- Or eslint. Provides "fix" actions.
        null_ls.builtins.code_actions.gitsigns, -- Code actions from gitsigns.nvim (if you use it)
        null_ls.builtins.code_actions.refactoring, -- If you use refactoring.nvim and its tools

        -- Example: Organize imports for Python with isort
        -- This can act as a code action and doesn't conflict with conform.nvim's full formatting
        -- if you invoke it specifically as a code action.
        -- null_ls.builtins.code_actions.isort.with({
        --    extra_args = {"--profile", "black"} -- Make isort compatible with black
        -- }),

        -- Add other linters or code action providers here.
        -- For example, for Go:
        -- null_ls.builtins.diagnostics.golangci_lint,

        -- IMPORTANT: DO NOT ADD FORMATTERS FROM null_ls.builtins.formatting
        -- e.g., DO NOT ADD null_ls.builtins.formatting.prettier
        -- e.g., DO NOT ADD null_ls.builtins.formatting.stylua
        -- conform.nvim is handling these!
      },
      -- on_attach function to run when none-ls attaches to a buffer.
      -- Useful for setting up buffer-local keymaps for LSP features.
      on_attach = an_on_attach,
    })
  end,
}
