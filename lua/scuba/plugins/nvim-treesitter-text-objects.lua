local selections = {
  ["a="] = "@assignment.outer",
  ["i="] = "@assignment.inner",
  ["l="] = "@assignment.lhs",
  ["r="] = "@assignment.rhs",
  ["a:"] = "@property.outer",
  ["i:"] = "@property.inner",
  ["l:"] = "@property.lhs",
  ["r:"] = "@property.rhs",
  aa = "@parameter.outer",
  ia = "@parameter.inner",
  ai = "@conditional.outer",
  ii = "@conditional.inner",
  al = "@loop.outer",
  il = "@loop.inner",
  af = "@call.outer",
  ["if"] = "@call.inner",
  am = "@function.outer",
  im = "@function.inner",
  ac = "@class.outer",
  ic = "@class.inner",
}

local moves = {
  ["]f"] = { "goto_next_start", "@call.outer" },
  ["]m"] = { "goto_next_start", "@function.outer" },
  ["]c"] = { "goto_next_start", "@class.outer" },
  ["]i"] = { "goto_next_start", "@conditional.outer" },
  ["]l"] = { "goto_next_start", "@loop.outer" },
  ["]s"] = { "goto_next_start", "@local.scope", "locals" },
  ["]z"] = { "goto_next_start", "@fold", "folds" },
  ["]F"] = { "goto_next_end", "@call.outer" },
  ["]M"] = { "goto_next_end", "@function.outer" },
  ["]C"] = { "goto_next_end", "@class.outer" },
  ["]I"] = { "goto_next_end", "@conditional.outer" },
  ["]L"] = { "goto_next_end", "@loop.outer" },
  ["[f"] = { "goto_previous_start", "@call.outer" },
  ["[m"] = { "goto_previous_start", "@function.outer" },
  ["[c"] = { "goto_previous_start", "@class.outer" },
  ["[i"] = { "goto_previous_start", "@conditional.outer" },
  ["[l"] = { "goto_previous_start", "@loop.outer" },
  ["[F"] = { "goto_previous_end", "@call.outer" },
  ["[M"] = { "goto_previous_end", "@function.outer" },
  ["[C"] = { "goto_previous_end", "@class.outer" },
  ["[I"] = { "goto_previous_end", "@conditional.outer" },
  ["[L"] = { "goto_previous_end", "@loop.outer" },
}

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  lazy = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select = require("nvim-treesitter-textobjects.select").select_textobject
    for key, query in pairs(selections) do
      vim.keymap.set({ "x", "o" }, key, function()
        select(query, "textobjects")
      end, { desc = "Select " .. query })
    end

    local swap = require("nvim-treesitter-textobjects.swap")
    for key, query in pairs({
      ["<leader>na"] = "@parameter.inner",
      ["<leader>n:"] = "@property.outer",
      ["<leader>nm"] = "@function.outer",
    }) do
      vim.keymap.set("n", key, function()
        swap.swap_next(query, "textobjects")
      end)
    end
    for key, query in pairs({
      ["<leader>pa"] = "@parameter.inner",
      ["<leader>p:"] = "@property.outer",
      ["<leader>pm"] = "@function.outer",
    }) do
      vim.keymap.set("n", key, function()
        swap.swap_previous(query, "textobjects")
      end)
    end

    local move = require("nvim-treesitter-textobjects.move")
    for key, target in pairs(moves) do
      vim.keymap.set({ "n", "x", "o" }, key, function()
        move[target[1]](target[2], target[3] or "textobjects")
      end)
    end

    local repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
    vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)
  end,
}
