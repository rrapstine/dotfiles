return {
  roles = { 'formatter' },
  formatter = {
    filetypes = { 'lua' },
    args = { '--config-path', vim.fn.stdpath('config') .. '/lua/config/formatters/stylua.toml' },
  }
}