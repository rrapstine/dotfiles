return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 'php' },
    root_dir = vim.fs.root(0, { 'composer.json', '.git' }),
    settings = {
      intelephense = {
        environment = {
          includePaths = {
            './vendor',
            '../',
          },
        },
      },
    },
  },
}

