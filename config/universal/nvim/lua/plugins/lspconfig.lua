return {
  {
    'neovim/nvim-lspconfig',
    -- Lazy load on actual file operations, not just VimEnter
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {},
        -- Mason should load slightly later, after UI is ready
        event = 'VeryLazy',
        -- Optional: Only load Mason when actually needed
        cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUpdate' },
      },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      local lsp_utils = require('config.lsp.utils')
      local tools_config = lsp_utils.discover_tools()

      -- Bring in mason-lspconfig
      require('mason-lspconfig').setup()

      require('mason-tool-installer').setup({
        ensure_installed = tools_config.mason_tools,
        run_on_start = true,
        auto_update = false,
      })

      -- Configure each LSP server before setup, then enable it
      for _, tool in ipairs(tools_config.lsp_tools) do
        local server_opts = tool.opts or {}

        -- Load user config and enable the server
        vim.lsp.config(tool.name, server_opts)
        vim.lsp.enable(tool.name)
      end

      -- Check if the client supports document highlight. Enable it if it does.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-document-highlight', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Skip null-ls and other non-code servers
          if not client or client.name == 'null-ls' then
            return
          end

          -- If THIS client supports highlighting, enable it (once)
          if client:supports_method('textDocument/documentHighlight', event.buf) then
            -- Check if already enabled for this buffer
            if not vim.b[event.buf].lsp_highlight_enabled then
              vim.b[event.buf].lsp_highlight_enabled = true

              -- Set up the autocmds
              local highlight_augroup = vim.api.nvim_create_augroup('user-lsp-highlight', { clear = true })
              vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
              })

              vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
              })

              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('user-lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds({ group = 'user-lsp-highlight', buffer = event2.buf })
                end,
              })
            end
          end
        end,
      })

      -- [[ Keymaps ]]
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-keymaps', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Skip null-ls and other non-code servers
          if not client or client.name == 'null-ls' then
            return
          end

          -- Enable basic semantic token highlighting (language-agnostic)
          if client:supports_method('textDocument/semanticTokens') then
            vim.api.nvim_set_hl(0, '@lsp.type.function', { link = 'Function' })
            vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = 'Identifier' })
            vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = 'Identifier' })
            vim.api.nvim_set_hl(0, '@lsp.type.method', { link = 'Function' })
            vim.api.nvim_set_hl(0, '@lsp.type.property', { link = 'Identifier' })
            vim.api.nvim_set_hl(0, '@lsp.type.class', { link = 'Type' })
            vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = 'Type' })
            vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = 'Type' })
          end

          -- Skip if keymaps already set for this buffer
          if vim.b[event.buf].lsp_keymaps_set then
            return
          end

          -- Mark this buffer as having keymaps set
          vim.b[event.buf].lsp_keymaps_set = true

          -- Batch keymap setup for better performance
          local lsp_maps = {
            { 'grn', vim.lsp.buf.rename, '[R]e[n]ame' },
            { 'gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' } },
            { 'grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences' },
            { 'gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation' },
            { 'grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition' },
            { 'grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration' },
            { 'gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols' },
            { 'gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols' },
            { 'grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition' },
            {
              '<leader>th',
              function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
              end,
              '[T]oggle Inlay [H]ints',
            },
          }

          for _, map in ipairs(lsp_maps) do
            vim.keymap.set(map[4] or 'n', map[1], map[2], { buffer = event.buf, desc = 'LSP: ' .. map[3] })
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
}
