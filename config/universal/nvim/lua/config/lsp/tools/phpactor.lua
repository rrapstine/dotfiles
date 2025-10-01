return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 'php' },
    root_dir = vim.fs.root(0, { 'composer.json', '.git', 'index.php' }),
    capabilities = (function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Disable capabilities that intelephense free already provides well
      capabilities.textDocument.completion = nil
      capabilities.textDocument.hover = nil
      capabilities.textDocument.signatureHelp = nil
      capabilities.textDocument.definition = nil
      capabilities.textDocument.references = nil
      capabilities.textDocument.documentHighlight = nil
      capabilities.textDocument.documentSymbol = nil
      capabilities.workspace.symbol = nil
      capabilities.textDocument.formatting = nil

      -- Keep only the premium features that intelephense free doesn't provide
      -- These will be phpactor's primary responsibilities:
      -- - codeAction (main goal!)
      -- - declaration
      -- - typeDefinition
      -- - implementation
      -- - rename
      -- - selectionRange

      return capabilities
    end)(),
    on_attach = function(client, bufnr)
      -- Explicitly disable overlapping capabilities at runtime
      client.server_capabilities.completionProvider = false
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.signatureHelpProvider = false
      client.server_capabilities.definitionProvider = false
      client.server_capabilities.referencesProvider = false
      client.server_capabilities.documentHighlightProvider = false
      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.workspaceSymbolProvider = false
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false

      -- Keep only these phpactor-specific capabilities
      -- client.server_capabilities.codeActionProvider = true (should remain enabled)
      -- client.server_capabilities.declarationProvider = true (should remain enabled)
      -- client.server_capabilities.typeDefinitionProvider = true (should remain enabled)
      -- client.server_capabilities.implementationProvider = true (should remain enabled)
      -- client.server_capabilities.renameProvider = true (should remain enabled)
      -- client.server_capabilities.selectionRangeProvider = true (should remain enabled)

      -- Optional: Add a notification that both servers are active
      print('Phpactor LSP started (complementing intelephense)')
    end,
    settings = {
      phpactor = {
        -- Disable indexing for better performance since intelephense handles most features
        ['indexer.enabled_watchers'] = {},
        ['completion.dedupe'] = false,
        ['completion.snippets'] = false,
        -- Focus on refactoring and premium features
        ['code_transform.class_new.variants'] = {
          ['symfony.doctrine.entity'] = 'default',
        },
      },
    },
  },
}

