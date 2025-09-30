return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- [[ mini.ai ]]
    require('mini.ai').setup()

    -- [[ mini.splitjoin ]]
    require('mini.splitjoin').setup()

    -- [[ mini.surround ]]
    require('mini.surround').setup()

    -- [[ mini.trailspace ]]
    require('mini.trailspace').setup({
      -- [[ Keymaps ]]
      vim.keymap.set('n', '<leader>cw', function()
        MiniTrailspace.trim()
      end, { desc = '[C]lear [w]hitespace in current buffer' }),
    })
  end,
}
