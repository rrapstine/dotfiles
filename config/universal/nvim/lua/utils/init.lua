local M = {}

M.get_user = function()
  local user = vim.env.USER or vim.env.USERNAME or ''
  return user:gsub('^%l', string.upper):gsub('%s+.*', '') -- Capitalize first letter and trim spaces
end

M.icons = require('utils.icons').icons
M.alpha_headers = require 'utils.alpha_headers'

return M
