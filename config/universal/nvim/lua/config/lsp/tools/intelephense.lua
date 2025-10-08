return {
  roles = { 'lsp' },
  lsp = {
    -- Using nvim-lspconfig defaults for:
    -- - filetypes: { 'php' }
    -- - root_dir: vim.fs.root(bufnr, { 'composer.json', '.git' })
    -- - cmd: { 'intelephense', '--stdio' }
    
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

