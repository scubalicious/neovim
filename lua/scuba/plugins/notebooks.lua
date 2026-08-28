return {
  {
    "Vigemus/iron.nvim",
    ft = "python",
    keys = {
      {
        "<leader>ji",
        function()
          require("iron.core").repl_for("python")
        end,
        desc = "Toggle IPython",
        ft = "python",
      },
      {
        "<leader>jl",
        function()
          require("iron.core").send_line()
        end,
        desc = "Send line to IPython",
        ft = "python",
      },
      {
        "<leader>js",
        function()
          require("iron.core").visual_send()
        end,
        desc = "Send selection to IPython",
        ft = "python",
        mode = "x",
      },
    },
    config = function()
      require("iron.core").setup({
        config = {
          repl_definition = { python = require("iron.fts.python").ipython },
          repl_open_cmd = require("iron.view").split.vertical.botright("40%"),
          scratch_repl = true,
        },
      })
    end,
  },
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = { "Vigemus/iron.nvim" },
    ft = "python",
    keys = {
      {
        "]j",
        function()
          require("notebook-navigator").move_cell("d")
        end,
        desc = "Next Python cell",
        ft = "python",
      },
      {
        "[j",
        function()
          require("notebook-navigator").move_cell("u")
        end,
        desc = "Previous Python cell",
        ft = "python",
      },
      {
        "<leader>jr",
        function()
          require("notebook-navigator").run_and_move()
        end,
        desc = "Run Python cell and advance",
        ft = "python",
      },
      {
        "<leader>jR",
        function()
          require("notebook-navigator").run_cell()
        end,
        desc = "Run Python cell",
        ft = "python",
      },
    },
    opts = {
      cell_markers = { python = "# %%" },
      repl_provider = "iron",
      syntax_highlight = true,
    },
  },
  {
    "sheng-tse/jupynvim",
    version = "v0.4.5",
    init = function()
      -- Herdr proxies Kitty graphics but preserves VS Code's terminal environment.
      if vim.env.HERDR_ENV == "1" and not vim.env.KITTY_WINDOW_ID then
        vim.env.KITTY_WINDOW_ID = "1"
      end
    end,
    build = function(plugin)
      local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
      install.run(plugin)
    end,
    opts = {
      image_renderer = "placeholder",
      terminal_keys = {},
      terminal_right_keys = {},
    },
  },
}
