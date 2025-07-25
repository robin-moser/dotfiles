return {
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      indent = {
        tab_char = "├",
      },
    },
  },
}
