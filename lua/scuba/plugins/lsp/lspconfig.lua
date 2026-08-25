local servers = { "basedpyright", "jsonls", "lua_ls", "ruff", "taplo", "ts_ls", "yamlls" }

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.workspace = capabilities.workspace or {}
    capabilities.workspace.fileOperations = {
      didCreate = true,
      didDelete = true,
      didRename = true,
      willCreate = true,
      willDelete = true,
      willRename = true,
    }
    vim.lsp.config("*", { capabilities = capabilities })

    vim.lsp.config("lua_ls", {
      on_init = function(client)
        local workspace = client.workspace_folders and client.workspace_folders[1].name
        if
          workspace ~= vim.fn.stdpath("config")
          and workspace
          and (vim.uv.fs_stat(workspace .. "/.luarc.json") or vim.uv.fs_stat(workspace .. "/.luarc.jsonc"))
        then
          return
        end

        client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
          runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
          workspace = {
            checkThirdParty = false,
            library = { vim.env.VIMRUNTIME, vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1] },
          },
        })
      end,
      settings = { Lua = { completion = { callSnippet = "Replace" } } },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(event)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
        end

        map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions")
        map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations")
        map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code actions")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")
        map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics")
        map("n", "[d", function()
          vim.diagnostic.jump({ count = -1 })
        end, "Previous diagnostic")
        map("n", "]d", function()
          vim.diagnostic.jump({ count = 1 })
        end, "Next diagnostic")
        map("n", "K", vim.lsp.buf.hover, "Show documentation")
        map("n", "<leader>rs", "<cmd>lsp restart<CR>", "Restart LSP")
      end,
    })

    vim.diagnostic.config({
      virtual_text = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
    })

    require("mason-lspconfig").setup({ ensure_installed = servers, automatic_enable = servers })
    require("mason-tool-installer").setup({
      ensure_installed = {
        "eslint_d",
        "jsonlint",
        "markdownlint",
        "prettier",
        "shellcheck",
        "shfmt",
        "stylua",
        "yamllint",
      },
    })
  end,
}
