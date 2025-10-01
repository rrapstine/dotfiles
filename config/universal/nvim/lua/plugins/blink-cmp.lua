return {
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'saghen/blink.compat',
        version = '2.*',
        lazy = true,
        opts = {},
      },
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        build = (function()
          if vim.fn.has('win32') == 1 or vim.fn.executable('make') == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
        opts = {},
      },
      'folke/lazydev.nvim',
      'huijiro/blink-cmp-supermaven',
    },

    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        --   <c-y> to accept ([y]es) the completion.
        --    This will auto-import if your LSP supports it.
        --    This will expand snippets if the LSP sent a snippet.
        -- 'super-tab' for tab to accept
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        preset = 'default',

        -- Remap ctrl + j/k to selecting suggestions
        ['<C-j>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-k>'] = { 'select_next', 'fallback_to_mappings' },

        -- Remap ctrl + l/h to jumping forward or backward in snippets
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },

        -- Remap ctrl + enter to accept
        ['<C-CR>'] = { 'select_and_accept' },

        -- Remap tab to complete suggested ghost text
        -- only when not in snippet mode
      },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        -- Optionally, set `auto_show = true` to show the documentation after a delay.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },

        -- Show ghost text, but do not show completion menu with it
        menu = { auto_show = false },
        ghost_text = { enabled = true, show_with_menu = false },
      },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'lazydev', 'supermaven', 'laravel' },
        providers = {
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          supermaven = {
            name = 'supermaven',
            module = 'blink-cmp-supermaven',
            async = true,
          },
          laravel = {
            name = 'laravel',
            module = 'blink.compat.source',
            score_offset = 95, -- show at a higher priority than lsp
          },
        },
      },

      snippets = { preset = 'luasnip' },
      fuzzy = { implementation = 'prefer_rust_with_warning' },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },
}
