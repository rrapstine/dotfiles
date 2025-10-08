return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'bash',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'php',
      'vim',
      'vimdoc',
      'javascript',
      'typescript',
      'tsx',
      'json',
      'yaml',
      'toml',
      'go',
      'rust',
    },
    auto_install = true,
    highlight = {
      enable = true,
      -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
      --  If you are experiencing weird indenting issues, add the language to
      --  the list of additional_vim_regex_highlighting and disabled languages for indent.
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },

  -- [[ Plugins ]]
  'nvim-treesitter/nvim-treesitter-context',
}
