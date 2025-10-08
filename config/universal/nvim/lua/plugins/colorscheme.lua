return {
  -- NOTE: Catppuccin Mocha
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  opts = {
    flavor = 'mocha',
    transparent_background = false,
    float = {
      transparent = false,
      solid = 'rounded',
    },
    dim_inactive = {
      enabled = false,
      shade = 'dark',
      percentage = 0.25,
    },
    auto_integrations = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = true,
      mini = {
        enabled = true,
        indentscope_color = '',
      },
    },
  },
}
