local function open_in_vscode(path)
  local code = vim.fn.exepath("code")
  if code == "" then
    vim.notify("VS Code CLI not found", vim.log.levels.ERROR)
    return
  end

  local function is_live_socket(socket)
    local stat = vim.uv.fs_stat(socket)
    return stat and stat.type == "socket" and stat.uid == vim.uv.getuid()
  end

  local sockets = vim.tbl_filter(is_live_socket, vim.fn.glob("/tmp/vscode-ipc-*.sock", false, true))
  table.sort(sockets, function(a, b)
    return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec
  end)

  -- Herdr can outlive the VS Code terminal it inherited this socket from.
  local inherited = vim.env.VSCODE_IPC_HOOK_CLI
  if inherited and is_live_socket(inherited) then
    sockets = vim.tbl_filter(function(socket)
      return socket ~= inherited
    end, sockets)
    table.insert(sockets, 1, inherited)
  end

  local function try_socket(index)
    local socket = sockets[index]
    if not socket then
      vim.notify("No live VS Code window found", vim.log.levels.ERROR)
      return
    end
    vim.system({ code, "--reuse-window", path }, { env = { VSCODE_IPC_HOOK_CLI = socket } }, function(result)
      if result.code ~= 0 then
        vim.schedule(function()
          try_socket(index + 1)
        end)
      end
    end)
  end

  try_socket(1)
end

local function preview_notebook_image()
  local path = vim.fn.stdpath("cache") .. "/jupynvim-preview.png"
  vim.uv.fs_unlink(path)
  require("jupynvim").save_image(0, path)
  if vim.uv.fs_stat(path) then
    open_in_vscode(path)
  end
end

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
    build = function(plugin)
      local install = loadfile(plugin.dir .. "/lua/jupynvim/install.lua")()
      install.run(plugin)
    end,
    opts = {
      -- Do not force Kitty detection in Herdr; VS Code rendering corrupts neighboring panes.
      image_renderer = "placeholder",
      terminal_keys = {},
      terminal_right_keys = {},
    },
    config = function(_, opts)
      require("jupynvim").setup(opts)
      vim.keymap.set("n", "<leader>np", preview_notebook_image, { desc = "Preview notebook image in VS Code" })
    end,
  },
}
