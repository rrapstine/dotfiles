return {
  roles = { 'lsp', 'formatter' },
  skip_mason = true, -- Don't install via Mason, use custom installation
  lsp = {
    filetypes = { 'fish' },
    cmd = { 'fish-lsp', 'start' },
  },
  formatter = {
    filetypes = { 'fish' },
  }
}