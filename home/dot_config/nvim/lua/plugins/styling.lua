return {
  {
    -- Colorscheme
    "navarasu/onedark.nvim",
    lazy = true,
    name = "onedark",
    opts = {
      style = "darker",
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },

  {
    -- Show colors aas virtual text
    "brenoprata10/nvim-highlight-colors",
    enabled = true,
    config = function()
      require("nvim-highlight-colors").setup({
        render = "virtual",
        virtual_symbol = "●",
        enable_tailwind = true,
      })
    end,
  },
  {
    -- Dashboard Header
    "folke/snacks.nvim",
    opts = function(_, opts)
      opts.dashboard.preset.header = table.concat({
        [[ ▄▄▄▄   ▄▄   ▄▄▄  ▄   ▄ ▄ ▄▄▄▄    ]],
        [[ █   █ █▄▄▀ █   █ ▜▖ ▗▛ ▄ █ █ █    ]],
        [[ █   █ ▀▄▄▄ ▀▄▄▄▀  ▜▄▛  █ █   █    ]],
        [[                        █          ]],
        [[                        █          ]],
      }, "\n")
      return opts
    end,
  },
}
