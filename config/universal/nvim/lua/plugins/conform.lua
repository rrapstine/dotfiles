return {
  'stevearc/conform.nvim',

  config = function()
    local ft_map, formatter_defs = require('config.lsp.tools').get_conform_config()

    require('conform').setup({
      formatters_by_ft = ft_map,
      formatters = formatter_defs,
      format_after_save = {
        async = true,
        timeout_ms = 500,
        lsp_format = 'fallback',
      },
    })

    -- [[ Keymaps ]]
    vim.keymap.set('', '<leader>f', function()
      require('conform').format()
    end, { desc = '[F]ormat buffer' })

    vim.g.conform_log_level = 'debug'
  end,
}
