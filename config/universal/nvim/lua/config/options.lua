-- Sync clipboard between neovim and OS
vim.opt.clipboard = 'unnamedplus'

-- Tell vim to automatically detect the filetype
vim.cmd('filetype on')

-- Enable nerdfonts
vim.g.have_nerd_font = true

-- Consistency
vim.g.editorconfig = true

-- Prompt save on quit, if necessary
vim.opt.confirm = true

-- User interface
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.scrolloff = 10
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.colorcolumn = '80'
vim.opt.showmode = false
vim.opt.winborder = 'rounded'
vim.opt.pumblend = 10

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs and indentation
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Folding, but not by default
vim.opt.foldmethod = 'indent'
vim.opt.foldlevelstart = 99

-- Searching and substitutions
vim.opt.incsearch = true
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Command completion
vim.opt.wildmode = 'longest:full,full'

-- Save undo history
vim.opt.undofile = true

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Backspace QoL
vim.opt.backspace = { 'start', 'eol', 'indent' }

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300
