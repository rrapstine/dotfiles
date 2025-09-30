local icons = require('utils').icons
local utils = require('utils')

local dashboard = require('dashboard')

local header = {
  '                                   ',
  '                                   ',
  '                                   ',
  '   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ',
  '    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ',
  '          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ',
  '           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ',
  '          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ',
  '   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ',
  '  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ',
  ' ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ',
  ' ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ',
  '      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ',
  '       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ',
  '                                   ',
}
dashboard.setup({
  theme = 'doom',
  config = {
    header = header,
    center = {
      {
        icon = icons.ui.file .. '  ',
        desc = string.format('%-50s', 'New file'),
        key = 'e',
        action = 'enew',
      },
      {
        icon = icons.ui.file .. '  ',
        desc = 'Recent Files',
        key = 'o',
        action = 'Telescope oldfiles',
      },
      {
        icon = icons.ui.open_folder .. '  ',
        desc = 'Explorer',
        key = 'f',
        action = 'Telescope find_files',
      },
      {
        icon = icons.ui.config .. '  ',
        desc = 'Neovim config',
        key = 'c',
        action = 'e ~/.config/nvim/lua/ | cd %:p:h',
      },
      {
        icon = '󰒲  ',
        desc = 'Lazy',
        key = 'l',
        action = 'Lazy',
      },
      {
        icon = icons.ui.lsp_info .. ' ',
        desc = 'Mason',
        key = 'm',
        action = 'Mason',
      },
      {
        icon = icons.ui.close .. '  ',
        desc = 'Quit NVIM',
        key = 'q',
        action = 'qa',
      },
    },
    footer = function()
      local datetime = os.date(' %H:%M. ')
      local num_plugins_loaded = require('lazy').stats().loaded
      return {
        '',
        'Hi ' .. utils.get_user() .. ',' .. ' It\'s' .. datetime .. 'How are you doing today?',
        '',
        '⚡' .. num_plugins_loaded .. ' plugins loaded.',
      }
    end,
  },

  -- Disable mini.trailspace on dashboard
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'dashboard',
    callback = function()
      vim.b.minitrailspace_disable = true
    end,
  }),
})
