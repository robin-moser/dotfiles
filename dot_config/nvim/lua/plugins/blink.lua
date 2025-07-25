return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",

        ["<Tab>"] = {
          function(cmp)
            -- Check if a Copilot suggestion is visible
            if require("copilot.suggestion").is_visible() then
              -- accept Copilot instead of cmp
              require("copilot.suggestion").accept()
            else
              if cmp.snippet_active() then
                return cmp.accept()
              else
                return cmp.select_and_accept()
              end
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      cmdline = {
        enabled = true,
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
    },
  },
}
