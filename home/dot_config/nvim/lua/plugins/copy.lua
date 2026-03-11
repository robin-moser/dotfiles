return {
  {
    "robin-moser/nvim-copy-rtf",
    dir = "/Users/robin/Development/nvim/nvim-copy-rtf",
    cmd = "ToRTF",
    config = function()
      vim.g.tortf_font = "Courier New"
      vim.g.tortf_bold = true
      vim.g.tortf_font_size = 14
      require("copy-rtf")
    end,
  },
}
