return {
  'stevearc/conform.nvim',

  config = function()
    local lsp_utils = require('config.lsp.utils')
    local tools_config = lsp_utils.discover_tools()

    require('conform').setup({
      formatters_by_ft = tools_config.formatters_by_ft,
      formatters = tools_config.formatter_configs,
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
