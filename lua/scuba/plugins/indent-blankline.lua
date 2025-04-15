return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufAdd", "BufReadPre", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { char = "┊" },
  },
}
