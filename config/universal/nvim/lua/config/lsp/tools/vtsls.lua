return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    root_dir = vim.fs.root(0, { 'package.json', '.git' }),
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
      },
    },
  },
}

