local excluded = {
  "node_modules/",
  "dist/",
  ".next/",
  ".vite/",
  ".git/",
  "build/",
  "target/",
  "package-lock.json",
  "pnpm-lock.yaml",
  "yarn.lock",
  ".DS_Store",
  "Thumbs.db",
  "desktop.ini",
  ".backups/",
}

return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    -- Set picker options
    opts = vim.tbl_deep_extend("force", opts or {}, {
      picker = {
        sources = {
          files = {
            hidden = true,
            ignored = false,
          },
        },
        hidden = true,
        ignored = false,
        exclude = excluded,
      },
    })

    -- Modify the action for the "new file" key in the dashboard
    opts.dashboard.preset.keys = opts.dashboard.preset.keys or {}
    for i, key in ipairs(opts.dashboard.preset.keys) do
      if key.key == "n" then
        -- was ":ene | startinsert" before
        opts.dashboard.preset.keys[i].action = ":ene"
        break
      end
    end

    return opts
  end,
}
