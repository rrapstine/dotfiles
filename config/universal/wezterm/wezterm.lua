-- =============================================================================
-- WezTerm Main Configuration
-- =============================================================================
-- Primary configuration file that composes all modules
-- =============================================================================

-- Imports & Setup
-- ---------------

local wezterm = require('wezterm')
local helpers = require('utils.helpers')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Create a variable for the multiplexer layer
local mux = wezterm.mux

-- Platform Detection
-- ------------------

-- Platform-specific environment variables and startup behavior
if helpers.is_macos then
  -- Set local PATH on macOS
  config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH'),
  }

  -- Maximize the window on startup
  wezterm.on('gui-startup', function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
  end)
end

-- Module Composition
-- ------------------

-- Apply appearance configuration
local apply_appearance = require('appearance')
config = apply_appearance(config)

-- Apply keybindings configuration
local apply_keybindings = require('keybindings')
config = apply_keybindings(config)

-- Plugin Loading
-- --------------

-- Initialize plugins
require('plugins/tabline')

-- Configuration Export
-- --------------------

return config
