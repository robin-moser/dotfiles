local pick_chezmoi = function()
  if LazyVim.pick.picker.name == "snacks" then
    local results = require("chezmoi.commands").list({
      args = {
        "--path-style",
        "absolute",
        "--include",
        "files",
        "--exclude",
        "externals",
      },
    })
    local items = {}
    for _, czFile in ipairs(results) do
      table.insert(items, {
        text = czFile,
        file = czFile,
      })
    end
    ---@type snacks.picker.Config
    local opts = {
      items = items,
      confirm = function(picker, item)
        picker:close()
        require("chezmoi.commands").edit({
          targets = { item.text },
          args = { "--watch" },
        })
      end,
    }
    Snacks.picker.pick(opts)
  end
end

return {
  {
    "darfink/vim-plist",
  },
  {
    "Jthaer/chezmoi.nvim",
    dir = "/Users/robin/Development/nvim/chezmoi.nvim",
    keys = {
      {
        "<leader>sz",
        pick_chezmoi,
        desc = "Chezmoi",
      },
    },
    opts = {
      edit = {
        encrypted = true,
      },
    },
  },
}
