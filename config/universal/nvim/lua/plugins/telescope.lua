return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require('telescope') -- Store telescope require in a local variable
    local builtin = require('telescope.builtin') -- Store builtin require in a local variable

    telescope.setup({
      defaults = {
        sorting_strategy = 'ascending',
        layout_config = {
          horizontal = { prompt_position = 'top', preview_width = 0.55 },
          vertical = { mirror = false },
        },
        path_display = { 'truncate' },
        file_ignore_patterns = { 'node_modules', '.git/' },
        border = true,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        color_devicons = true,
        set_env = { ['COLORTERM'] = 'truecolor' },
      },
      extensions = {
        ['ui-select'] = require('telescope.themes').get_dropdown(),
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        },
      },
    })

    -- [[ Extensions ]]
    pcall(telescope.load_extension, 'fzf') -- Use the local variable
    pcall(telescope.load_extension, 'ui-select') -- Use the local variable

    -- [[ Keymaps ]]
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = '[S]earch Select [T]elescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Fuzzy search in current buffer
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- Grep in all open files
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep({
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      })
    end, { desc = '[S]earch [/] in Open Files' })

    -- Search neovim config files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = '[S]earch [N]eovim files' })

    -- New keymap: Search All files (including hidden and .gitignored)
    vim.keymap.set('n', '<leader>sa', function()
      builtin.find_files({
        prompt_title = 'Search All Files (Hidden & Ignored)',
        hidden = true,
        no_ignore = true,
        no_ignore_vcs = true,
        find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
        layout_strategy = 'vertical',
        layout_config = { width = 0.95 },
      })
    end, { desc = '[S]earch [A]ll (Hidden/Ignored)' })

    -- Search all Neovim messages and notifications (including noice history)
    vim.keymap.set('n', '<leader>sm', function()
      pcall(telescope.extensions.noice.noice)
    end, { desc = '[S]earch [M]essages/Notifications' })
  end,
}
