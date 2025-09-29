return {
  'supermaven-inc/supermaven-nvim',
  lazy = false,

  config = function()
    require('supermaven-nvim').setup({
      disable_inline_completion = false,
      disable_keymaps = false,
    })
  end,
}
