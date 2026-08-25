return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    local transparent = false

    local function apply()
      require("tokyonight").setup({
        style = "moon",
        transparent = transparent,
        styles = {
          sidebars = transparent and "transparent" or "dark",
          floats = transparent and "transparent" or "dark",
        },
      })
      vim.cmd.colorscheme("tokyonight")
    end

    apply()
    vim.keymap.set("n", "<leader>bg", function()
      transparent = not transparent
      apply()
      vim.notify("Neovim background: " .. (transparent and "Transparent" or "Opaque"))
    end, { desc = "Toggle Neovim background transparency" })
  end,
}
