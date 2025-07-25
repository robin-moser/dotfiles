return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        yaml = true,
        markdown = true,
      },
    },
    config = function(_, opts)
      -- Ensure the copilot client is initialized,
      -- if it should start at Vim startup.
      if vim.g.copilot_enabled then
        require("copilot").setup(opts)
      end
      Snacks.toggle({
        name = "Github Copilot",
        get = function()
          return vim.g.copilot_enabled
        end,
        set = function(state)
          if state then
            -- if copilot is not setup yet, we have to set it up
            if not require("copilot").setup_done then
              vim.notify("Setting up Copilot...", "warn")
              require("copilot").setup(opts)
            end
            -- enable copilot
            require("copilot.command").enable()
            vim.g.copilot_enabled = true
          else
            -- disable copilot
            require("copilot.command").disable()
            vim.g.copilot_enabled = false
          end
        end,
      }):map("<leader>ai")
    end,
  },
  {
    "cousine/opencode-context.nvim",
    opts = {
      tmux_target = nil, -- Manual override: "session:window.pane"
      auto_detect_pane = true, -- Auto-detect opencode pane in current window
    },
    keys = {
      { "<leader>oc", "<cmd>OpencodeSend<cr>", desc = "Send prompt to opencode" },
      { "<leader>oc", "<cmd>OpencodeSend<cr>", mode = "v", desc = "Send prompt to opencode" },
      { "<leader>ot", "<cmd>OpencodeSwitchMode<cr>", desc = "Toggle opencode mode" },
      { "<leader>op", "<cmd>OpencodePrompt<cr>", desc = "Open opencode persistent prompt" },
    },
    cmd = { "OpencodeSend", "OpencodeSwitchMode" },
  },
}
