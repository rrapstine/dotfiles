-- lua/config/lsp/utils.lua
-- Auto-discovery utilities for LSP tools configuration

local M = {}

--- Validates a tool configuration structure
--- @param tool_name string: Name of the tool for error reporting
--- @param config table: Tool configuration to validate
--- @return boolean: True if valid, false otherwise
--- @return string|nil: Error message if invalid
function M.validate_tool_config(tool_name, config)
  -- Check required fields
  if not config.roles or type(config.roles) ~= 'table' or #config.roles == 0 then
    return false, 'Tool ' .. tool_name .. ' must have non-empty roles array'
  end

  -- Validate role values
  local valid_roles = { 'lsp', 'formatter', 'linter' }
  for _, role in ipairs(config.roles) do
    if not vim.tbl_contains(valid_roles, role) then
      return false, 'Tool ' .. tool_name .. ' has invalid role: ' .. tostring(role) .. '. Valid roles: ' .. table.concat(valid_roles, ', ')
    end
  end

  -- Validate role-specific configurations (only if not disabled at role level)
  if vim.tbl_contains(config.roles, 'lsp') and not config.lsp then
    return false, 'Tool ' .. tool_name .. ' has lsp role but missing lsp configuration'
  end

  if vim.tbl_contains(config.roles, 'formatter') and not config.formatter then
    return false, 'Tool ' .. tool_name .. ' has formatter role but missing formatter configuration'
  end

  if vim.tbl_contains(config.roles, 'linter') and not config.linter then
    return false, 'Tool ' .. tool_name .. ' has linter role but missing linter configuration'
  end

  -- Validate formatter configuration if present
  if config.formatter and config.formatter.enabled ~= false then
    if not config.formatter.filetypes or type(config.formatter.filetypes) ~= 'table' or #config.formatter.filetypes == 0 then
      return false, 'Tool ' .. tool_name .. ' formatter must have non-empty filetypes array'
    end
  end

  return true
end

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

    -- If tool is disabled, skip it
    if tool_config.enabled == false then
      goto continue
    end

    -- Validate tool configuration
    local valid, error_msg = M.validate_tool_config(tool_name, tool_config)
    if not valid and error_msg then
      vim.notify(error_msg, vim.log.levels.ERROR)
      goto continue
    end

    -- Skip disabled tools completely (opt-out: only disable if explicitly false)
    if tool_config.enabled == false then
      vim.notify('Tool ' .. tool_name .. ' is disabled, skipping completely', vim.log.levels.DEBUG)
      goto continue
    end

    -- Add to mason_tools list if not explicitly skipped
    if not tool_config.skip_mason then
      table.insert(result.mason_tools, tool_name)
    end

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
