return {
  'nvim-lualine/lualine.nvim',
  depencencies = { 'nvim-tree/nvim-web-devicons' },

  config = function()
    require('config/lualine')
  end,
}
