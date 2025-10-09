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
    
    -- Enable Treesitter highlighting and indentation (Neovim 0.11+)
    vim.api.nvim_create_autocmd({'FileType', 'BufEnter'}, {
      group = vim.api.nvim_create_augroup('treesitter_enable', { clear = true }),
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        
        if ft and ft ~= '' then
          -- Enable Treesitter highlighting (built-in to Neovim 0.11+)
          pcall(vim.treesitter.start, buf)
          
          -- Enable Treesitter indentation (from nvim-treesitter plugin)
          -- Only set if we have a valid parser and indent queries
          local lang = vim.treesitter.language.get_lang(ft)
          if lang then
            local ok, _ = pcall(vim.treesitter.query.get, lang, 'indents')
            if ok then
              vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
          end
        end
      end,
    })
  end,
}
