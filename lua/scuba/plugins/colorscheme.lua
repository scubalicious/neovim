return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    -- This global variable will be used by tokyonight to enable/disable transparency
    -- Set the initial state here.
    vim.g.tokyonight_transparent_bg = false -- Start with opaque background

    -- Initial setup based on the global variable
    require("tokyonight").setup({
      style = "moon",
      transparent = vim.g.tokyonight_transparent_bg, -- Use the global variable
      -- Optional: if you want sidebars/floats to also follow the global transparency
      styles = {
        sidebars = vim.g.tokyonight_transparent_bg and "transparent" or "dark",
        floats = vim.g.tokyonight_transparent_bg and "transparent" or "dark",
      },
      -- No on_colors needed if you're not overriding colors
    })

    -- Apply the colorscheme initially
    vim.cmd("colorscheme tokyonight")

    -- Function to toggle the transparency
    local toggle_transparency = function()
      -- Toggle the global variable
      vim.g.tokyonight_transparent_bg = not vim.g.tokyonight_transparent_bg

      -- To make TokyoNight re-evaluate its `transparent` option,
      -- we need to unload and reload it, or call a function if it provides one.
      -- The most reliable way if the plugin doesn't offer a dedicated refresh function
      -- is to unload and re-require its setup.

      -- Unload the module to ensure setup is re-run with new global var value
      package.loaded["tokyonight"] = nil
      package.loaded["tokyonight.config"] = nil -- Common place for setup logic
      -- Potentially other submodules if the plugin structures them that way

      -- Re-run the setup with the updated global variable
      require("tokyonight").setup({
        style = "moon",
        transparent = vim.g.tokyonight_transparent_bg,
        styles = {
          sidebars = vim.g.tokyonight_transparent_bg and "transparent" or "dark",
          floats = vim.g.tokyonight_transparent_bg and "transparent" or "dark",
        },
      })

      -- Re-apply the colorscheme
      vim.cmd("colorscheme tokyonight")

      vim.notify(
        "Neovim background: " .. (vim.g.tokyonight_transparent_bg and "Transparent (via WezTerm)" or "Opaque"),
        vim.log.levels.INFO
      )
    end

    -- Keymap to toggle transparency
    vim.keymap.set(
      "n",
      "<leader>bg", -- Or your preferred keymap
      toggle_transparency,
      { noremap = true, silent = true, desc = "Toggle Neovim background transparency" }
    )
  end,
}
