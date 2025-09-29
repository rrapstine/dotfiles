return {
  'rmagatti/auto-session',
  enabled = false,

  config = function()
    require('auto-session').setup({
      bypass_save_filetypes = { 'alpha', 'dashboard' },
      auto_restore_enabled = false,
      suppress_dirs = { '~/', '~/Code', '~/Downloads', '~/Documents', '~/Desktop' },
      session_lens = {
        buftypes_to_ignore = {},
        load_on_setup = true,

        previewer = false,
        theme_conf = { border = true },
      },
    })
    -- stylua: ignore
    vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions',

    -- [[ Keymaps ]]
    vim.keymap.set('n', '<leader>ss', "<cmd>AutoSession search<CR>", {
      desc = '[S]earch [S]ession'
    })
    vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = '[S]ave current [w]orkspace session' })
    vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = '[R]estore current [w]orkspace session' })
  end,
}
