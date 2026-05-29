return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = { enable = true, style = { { fg = "#F9B34C" } }, use_treesitter = true },
    line_num = { enable = true, style = { { fg = "#F9B34C" } } },
    blank = { enable = false },
  },
}