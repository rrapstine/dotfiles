return {
  'mrjones2014/smart-splits.nvim',
  lazy = false,
  config = function()
    require('smart-splits').setup({
      at_edge = 'stop',
    })

    vim.keymap.set('n', '<A-h>', require('smart-splits').move_cursor_left, { desc = 'Move to left pane/split' })
    vim.keymap.set('n', '<A-j>', require('smart-splits').move_cursor_down, { desc = 'Move to lower pane/split' })
    vim.keymap.set('n', '<A-k>', require('smart-splits').move_cursor_up, { desc = 'Move to upper pane/split' })
    vim.keymap.set('n', '<A-l>', require('smart-splits').move_cursor_right, { desc = 'Move to right pane/split' })
  end,
}
