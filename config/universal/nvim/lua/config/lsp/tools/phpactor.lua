return {
  roles = { 'lsp' },
  lsp = {
    filetypes = { 'php' },
    root_dir = vim.fs.root(0, { 'composer.json', '.git', 'index.php' }),
    handlers = {
      ['textDocument/publishDiagnostics'] = function() end,
    },
    capabilities = {
      textDocument = {
        -- Disable what FREE intelephense provides
        completion = nil,
        hover = nil,
        signatureHelp = nil,
        definition = nil,
        references = nil,
        documentHighlight = nil,
        documentSymbol = nil,
        formatting = nil,
        rangeFormatting = nil,
        publishDiagnostics = nil,

        -- KEEP what FREE intelephense lacks (premium features)
        foldingRange = {
          dynamicRegistration = false,
        },
        implementation = {
          dynamicRegistration = false,
          linkSupport = true,
        },
        declaration = {
          dynamicRegistration = false,
          linkSupport = true,
        },
        typeDefinition = {
          dynamicRegistration = false,
          linkSupport = true,
        },
        rename = {
          dynamicRegistration = false,
          prepareSupport = true,
        },
        selectionRange = {
          dynamicRegistration = false,
        },
        codeAction = {
          dynamicRegistration = false,
          codeActionLiteralSupport = {
            codeActionKind = {
              valueSet = {
                'quickfix',
                'refactor',
                'refactor.extract',
                'refactor.inline',
                'refactor.rewrite',
              },
            },
          },
        },
      },
      workspace = {
        symbol = nil, -- intelephense handles this
      },
    },

    settings = {
      phpactor = {
        ['indexer.enabled_watchers'] = {},
        ['completion.dedupe'] = false,
        ['completion.snippets'] = false,
        ['code_transform.class_new.variants'] = {
          ['symfony.doctrine.entity'] = 'default',
        },
      },
    },
  },
}
