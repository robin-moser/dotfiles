return {
  {
    "smoka7/hop.nvim",
    opts = {
      keys = "asdfjklcvbnmqwertuiopzxgh",
      },
    config = function(_, opts)
      local hop = require("hop")
      hop.setup(opts)

      local directions = require("hop.hint").HintDirection

      vim.keymap.set("n", "<Leader>j", function()
        hop.hint_words({ direction = directions.AFTER_CURSOR, current_line_only = false })
      end, { noremap = true, desc = "Hop to character after cursor" })

      vim.keymap.set("n", "<Leader>k", function()
        hop.hint_words({ direction = directions.BEFORE_CURSOR, current_line_only = false })
      end, { noremap = true, desc = "Hop to character after cursor" })
    end,
  },
}
