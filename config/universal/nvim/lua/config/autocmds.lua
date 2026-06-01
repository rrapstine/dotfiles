-- Oil cursorline
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

-- Disable mini.trailspace on dashboard
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "dashboard",
--   callback = function()
--     vim.b.minitrailspace_disable = true
--   end,
-- })

