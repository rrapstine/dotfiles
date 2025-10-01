return {
  roles = { 'formatter' },
  formatter = {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
    args = {
      'format',
      '--config-path',
      vim.fn.stdpath('config') .. '/lua/config/formatters/biome.jsonc',
      '$FILENAME',
    },
  },
  linter = {
    command = 'biome',
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
    args = {
      'lint',
      '--config-path',
      vim.fn.stdpath('config') .. '/lua/config/formatters/biome.jsonc',
      '$FILENAME',
    },
  },
}
