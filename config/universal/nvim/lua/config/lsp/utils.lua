-- lua/config/lsp/utils.lua
-- Auto-discovery utilities for LSP tools configuration

local M = {}

--- Discovers and processes all tool configurations from the tools directory
--- @return table: { mason_tools = {...}, lsp_tools = {{name, opts}...}, formatters_by_ft = {...}, formatter_configs = {...} }
function M.discover_tools()
  local result = {
    mason_tools = {},
    lsp_tools = {},
    formatters_by_ft = {},
    formatter_configs = {},
  }

  -- Get all .lua files in the tools directory
  local tools_path = vim.fn.stdpath('config') .. '/lua/config/lsp/tools'
  local files = vim.fn.globpath(tools_path, '*.lua', true, true)

  for _, file in ipairs(files) do
    local tool_name = vim.fn.fnamemodify(file, ':t:r') -- get filename without extension

    -- Safely require the tool configuration
    local ok, tool_config = pcall(require, 'config.lsp.tools.' .. tool_name)
    if not ok then
      vim.notify('Failed to load tool config: ' .. tool_name .. ' - ' .. tool_config, vim.log.levels.ERROR)
      goto continue
    end

    -- Validate required fields
    if not tool_config.roles or type(tool_config.roles) ~= 'table' then
      vim.notify('Tool ' .. tool_name .. ' missing or invalid roles field', vim.log.levels.ERROR)
      goto continue
    end

    -- Add ALL tools to mason_tools list for installation (regardless of role)
    table.insert(result.mason_tools, tool_name)

    -- Process each role
    for _, role in ipairs(tool_config.roles) do
      if role == 'lsp' then
        -- Add to LSP tools array with name and opts
        if tool_config.lsp then
          table.insert(result.lsp_tools, {
            name = tool_name,
            opts = tool_config.lsp,
          })
        else
          vim.notify('LSP tool ' .. tool_name .. ' missing lsp configuration', vim.log.levels.WARN)
        end
      elseif role == 'formatter' then
        -- Configure formatter for Conform
        if tool_config.formatter then
          local formatter_config = tool_config.formatter

          -- Add to formatters_by_ft mapping
          if formatter_config.filetypes then
            for _, ft in ipairs(formatter_config.filetypes) do
              result.formatters_by_ft[ft] = result.formatters_by_ft[ft] or {}
              table.insert(result.formatters_by_ft[ft], tool_name)
            end
          end

          -- Add custom formatter configuration if args are specified
          if formatter_config.args then
            result.formatter_configs[tool_name] = {
              inherit = true,
              prepend_args = formatter_config.args,
            }
          end
        else
          vim.notify('Formatter tool ' .. tool_name .. ' missing formatter configuration', vim.log.levels.WARN)
        end
      elseif role == 'linter' then
        -- Handle linter configuration (placeholder for future nvim-lint integration)
        if tool_config.linter then
          -- TODO: Implement linter configuration when needed
          vim.notify('Linter role found for ' .. tool_name .. ' but linter integration not implemented yet', vim.log.levels.INFO)
        end
      end
    end

    ::continue::
  end

  return result
end

return M

