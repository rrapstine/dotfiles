return {
  enabled = true,
  roles = { 'lsp' },
  lsp = {
    settings = {
      vtsls = {
        autoUseWorkspaceTsdk = true,
        typescript = {
          tsserver = {
            useSyntaxServer = 'auto',
            -- These might be needed for proper JSX highlighting
            preferences = {
              includePackageJsonAutoImports = 'on',
            },
            -- Enable semantic highlighting features
            semanticHighlighting = {
              enabled = true,
            },
          },
        },
        -- Additional vtsls-specific settings that might be needed
        javascript = {
          suggestions = {
            completeFunctionCalls = true,
          },
        },
      },
    },
  },
}
