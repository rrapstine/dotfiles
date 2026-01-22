local wezterm = require('wezterm')

local config = wezterm.config_builder()

local platform = require('config.platform')
local appearance = require('config.appearance')
local keybindings = require('config.keybindings')
local sessions = require('config.sessions')

sessions.setup(wezterm)

platform.apply(config, wezterm)
appearance.apply(config, wezterm)
keybindings.apply(config, wezterm)

config.unix_domains = {
  { name = 'unix' },
}
config.default_gui_startup_args = { 'connect', 'unix' }

require('plugins/tabline')

return config
