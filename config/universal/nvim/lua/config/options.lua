-- Colorscheme (separate from theme plugin config for easy swapping)
vim.g.lazyvim_colorscheme = "catppuccin"

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Nerd fonts
vim.g.have_nerd_font = true

-- Overrides that differ from LazyVim defaults
vim.opt.scrolloff = 10 -- LazyVim default is 4
vim.opt.colorcolumn = "80" -- Not set by LazyVim
vim.opt.winborder = "rounded" -- Not set by LazyVim
vim.opt.wildmode = "longest:full,full" -- Better CLI tab completion
vim.opt.backspace = { "start", "eol", "indent" } -- Not set by LazyVim