return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    require('nvim-treesitter.configs').setup({
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
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
    })
  end,
}
