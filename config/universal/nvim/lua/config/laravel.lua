-- lua/config/laravel.lua
local M = {}

-- Simple function to get container name
local function get_container_name()
  -- Check environment variable first
  local container = vim.env.LARAVEL_NVIM_CONTAINER
  if container then
    return container
  end
  
  -- Prompt user (this will only happen in Laravel projects now due to cond())
  local default = 'api'
  local user_input = vim.fn.input('Laravel container name (default: api): ', default)
  return user_input ~= '' and user_input or default
end

function M.get_environments()
  local base_envs = require("laravel.options.environments")
  local container_name = get_container_name()
  
  -- Simple podman-compose environment
  local podman_env = {
    name = "podman-compose (" .. container_name .. ")",
    map = {
      php = { "podman", "compose", "exec", "-it", container_name, "php" },
      composer = { "podman", "compose", "exec", "-it", container_name, "composer" },
      npm = { "podman", "compose", "exec", "-it", container_name, "npm" },
      yarn = { "podman", "compose", "exec", "-it", container_name, "yarn" },
      artisan = { "podman", "compose", "exec", "-it", container_name, "php", "artisan" },
    },
  }
  
  return vim.tbl_deep_extend('force', base_envs, {
    definitions = vim.list_extend(base_envs.definitions, { podman_env })
  })
end

return M