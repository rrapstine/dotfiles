return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- Configure nvim-treesitter (for parser installation)
    require('nvim-treesitter').setup({
      sync_install = false,
      auto_install = true,
      ignore_install = {},
      ensure_installed = {
        'bash',
        'css',
        'go',
        'fish',
        'html',
        'javascript',
        'json',
        'lua',
        'markdown',
        'python',
        'rust',
        'toml',
        'typescript',
        'tsx',
        'yaml',
      },
    })
    
    -- Enable Treesitter highlighting (Neovim 0.11+ built-in)
    vim.api.nvim_create_autocmd({'FileType', 'BufEnter'}, {
      group = vim.api.nvim_create_augroup('treesitter_highlight', { clear = true }),
      callback = function(args)
        local buf = args.buf
        -- Only enable for parsers that exist
        local ft = vim.bo[buf].filetype
        if ft and ft ~= '' then
          local ok = pcall(vim.treesitter.start, buf)
          if not ok then
            -- Parser doesn't exist for this filetype, that's fine
          end
        end
      end,
    })
  end,
}
