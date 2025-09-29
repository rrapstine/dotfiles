local opts = { noremap = true, silent = true }
local keys = vim.keymap

-- [[ Basic Keymaps ]]

-- Leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Change some default navigation keys to match Helix, which I find more intuitive
keys.set('n', 'ge', 'G', { desc = 'Jump to end of file' })
keys.set('n', 'gh', '^', { desc = 'Jump to start of line' })
keys.set('n', 'gl', '$', { desc = 'Jump to end of line' })

-- Allow moving up and down in wrapped text
keys.set('n', 'j', 'v:count == 0 ? \'gj\' : \'j\'', { expr = true })
keys.set('n', 'k', 'v:count == 0 ? \'gk\' : \'k\'', { expr = true })

-- Set Q to behave like :q
keys.set('n', 'Q', ':q<CR>')

-- Easily append ; or , to end of line
keys.set('i', ';;', '<Esc>A;<Esc>')
keys.set('i', ',,', '<Esc>A,<Esc>')

-- Undo the last undo, inspired by Helix
keys.set('n', 'U', '<C-R>', { desc = 'Redo the last change' })

-- Move lines vertically in different modes
keys.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line up in normal mode' })
keys.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line down in normal mode' })

keys.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { desc = 'Move line up in insert mode' })
keys.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line down in insert mode' })

keys.set('v', '<A-k>', ':m \'<-2<CR>gv=gv', { desc = 'Move line(s) up in visual mode' })
keys.set('v', '<A-j>', ':m \'>+1<CR>gv=gv', { desc = 'Move line(s) down in visual mode' })

-- Keep cursor centered while scrolling with Ctrl+D/U
keys.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up in buffer, with cursor centered' })
keys.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down in buffer, with cursor centered' })

-- Keep cursor centered when jumping through search results
keys.set('n', 'n', 'nzzzv', { desc = 'Goto next search result, with cursor centered' })
keys.set('n', 'N', 'Nzzzv', { desc = 'Goto previous search result, with cursor centered' })

-- Indent in visual mode
keys.set('v', '>', '>gv', opts, { desc = 'Indent in visual mode' })
keys.set('v', '<', '<gv', opts, { desc = 'Unindent in visual mode' })

-- Prevent copying deleted characters to clipboard
keys.set('n', 'x', '"_x', opts)

-- Set paste to use "black hole" register in visual mode
keys.set('v', 'p', '"_dP')

-- Global search and replace under cursor
-- TODO: Look into a better way to do this, perhaps a multi-cursor plugin
keys.set('n', 'S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Replace word under cursor, globally' })

-- Clear highlights on search when pressing <Esc> in normal mode
keys.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keys.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Open terminal mode in a vertical split
keys.set('n', '<leader>tt', '<cmd>vsplit | terminal<CR>', { desc = 'Open terminal in a vertical split' })

-- Exit terminal mode easier
keys.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Use CTRL+<hjkl> to switch between windows
keys.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keys.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keys.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keys.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic AutoCommands ]]

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
