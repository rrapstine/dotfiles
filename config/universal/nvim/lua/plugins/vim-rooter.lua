return {
  enabled = false,
  'airblade/vim-rooter',

  -- Instead of running each time a file is opened...
  setup = function()
    vim.g.rooter_manual_only = 1
  end,

  -- Run it once when Vim starts and then stop.
  config = function()
    vim.cmd('Rooter')
  end,
}
