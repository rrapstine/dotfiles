-- lua/config/laravel.lua
-- Custom Laravel.nvim environment configuration with podman support

local M = {}

-- Function to get container name with user prompt and smart default
local function get_container_name()
  -- Smart default based on common patterns
  local default = 'api'
  
  local user_input = vim.fn.input('Container name (default: api): ', default)
  return user_input ~= '' and user_input or default
end

-- Generate custom environments with dynamic container detection
function M.get_environments()
  local base_envs = require("laravel.options.environments")
  
  -- Only prompt for container name when we actually need it
  local container_name = get_container_name()
  
  -- Custom podman-compose environment with user-specified container
  local podman_compose_env = {
    name = "podman-compose (" .. container_name .. ")",
    map = {
      php = { "podman", "compose", "exec", "-it", container_name, "php" },
      composer = { "podman", "compose", "exec", "-it", container_name, "composer" },
      npm = { "podman", "compose", "exec", "-it", container_name, "npm" },
      yarn = { "podman", "compose", "exec", "-it", container_name, "yarn" },
    },
  }
  
  -- Return modified environments with our custom podman environment
  return vim.tbl_deep_extend('force', base_envs, {
    definitions = vim.list_extend(base_envs.definitions, { podman_compose_env })
  })
end

return M