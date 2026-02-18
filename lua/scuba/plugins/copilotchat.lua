return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- updated to use lua version
      { "nvim-lua/plenary.nvim" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
      model = "claude-sonnet-4", -- Updated to use a valid model
      agent = "copilot", -- This enables the default GitHub Copilot agent
      window = {
        layout = "vertical",
        border = "rounded",
      },
      mappings = {
        reset = {
          normal = "<C-p>",
          insert = "<C-p>",
        },
      },
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat", mode = { "n", "v" } },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain Code", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Generate Tests", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix Code", mode = { "n", "v" } },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize Code", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Generate Docs", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Review Code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>CopilotChatCommit<cr>", desc = "Generate Commit Message", mode = { "n", "v" } },
    },
    -- config = function()
    --   -- Custom save command that prompts for name with timestamp default
    --   vim.api.nvim_create_user_command("CopilotChatSaveNamed", function()
    --     local timestamp = os.date("%Y%m%d_%H%M%S")
    --     local default_name = "chat_" .. timestamp
    --
    --     vim.ui.input({
    --       prompt = "Session name: ",
    --       default = default_name,
    --     }, function(name)
    --       if name and name ~= "" then
    --         vim.cmd("CopilotChatSave " .. name)
    --       end
    --     end)
    --   end, {})
    --
    --   -- Add keymaps for session management
    --   vim.keymap.set({ "n", "v" }, "<leader>cas", ":CopilotChatSaveNamed<CR>", { desc = "Save chat session with name" })
    --   vim.keymap.set({ "n", "v" }, "<leader>cal", ":CopilotChatLoad<CR>", { desc = "Load chat session" })
    -- end,
    -- -- See Commands section for default commands if you want to lazy load on them
  },
}
