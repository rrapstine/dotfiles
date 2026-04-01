return {
  'zbirenbaum/copilot.lua',

  requires = {
    'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
  },

  cmd = 'Copilot',
  event = 'InsertEnter',
  opts = {
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      markdown = true,
      help = true,
    },
  },
}
