-- When both machines are on Neovim 0.12+, unpin version and switch to:
-- require('nvim-treesitter').setup({ ... }) (no highlight/indent keys)
-- Then uncomment the autocmd below and remove highlight/indent from setup:
--
-- vim.api.nvim_create_autocmd('FileType', {
--   callback = function(args)
--     local buf = args.buf
--     pcall(vim.treesitter.start, buf)
--     local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
--     if lang then
--       local ok, query = pcall(vim.treesitter.query.get, lang, 'indents')
--       if ok and query then
--         vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--       end
--     end
--   end,
-- })
--
return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  version = 'v0.10.0',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
      sync_install = false,
      auto_install = true,
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
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
