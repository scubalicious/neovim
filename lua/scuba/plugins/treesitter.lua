local parsers = {
  "bash",
  "c",
  "cmake",
  "css",
  "csv",
  "dockerfile",
  "gitignore",
  "go",
  "graphql",
  "groovy",
  "html",
  "java",
  "javascript",
  "json",
  "latex",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "prisma",
  "python",
  "query",
  "r",
  "regex",
  "rnoweb",
  "sql",
  "svelte",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    { "windwp/nvim-ts-autotag", opts = {} },
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 3,
        multiline_threshold = 10,
        mode = "cursor",
        separator = "─",
      },
    },
  },
  config = function()
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        if pcall(vim.treesitter.start) then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    vim.keymap.set({ "n", "x" }, "<C-space>", function()
      vim.treesitter.select("parent")
    end, { desc = "Select parent syntax node" })
    vim.keymap.set("x", "<BS>", function()
      vim.treesitter.select("child")
    end, { desc = "Select child syntax node" })
  end,
}
