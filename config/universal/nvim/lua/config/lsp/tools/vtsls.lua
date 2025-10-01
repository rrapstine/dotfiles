return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json', 'jsonc' },
    root_dir = vim.fs.root(0, { 'package.json', '.git' }),
  }
}