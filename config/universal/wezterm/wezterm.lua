-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Create a variable for the multiplexer layer
local mux = wezterm.mux

-- Check if current OS is MacOS
local is_macos = wezterm.target_triple:find('apple%-darwin')

-- Set the color scheme
config.color_scheme = 'catppuccin-mocha'

-- MacOS Specific Settings
if is_macos then
  -- Set local PATH on MacOS
  config.set_environment_variables = {
    PATH = '/opt/homebrew/bin:' .. os.getenv('PATH'),
  }

  -- Maximize the window on startup
  wezterm.on('gui-startup', function()
    local tab, pane, window = mux.spawn_window({})
    window:gui_window():maximize()
  end)

  -- Set blur on MacOS
  if is_macos then
    config.macos_window_background_blur = 10
  end

  -- Remove window decorations on MacOS
  -- This is needed because, setting this universlly breaks things on Hyprland
  config.window_decorations = 'RESIZE'
end

-- Smoother animation
config.max_fps = 120

-- Window configuration
-- config.window_background_opacity = 0.9

config.window_padding = config.window_padding or {}
config.window_padding.left = 4
config.window_padding.right = 4
config.window_padding.top = 4
config.window_padding.bottom = 4

config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32

config.colors = config.colors or {}
config.colors.tab_bar = config.colors.tab_bar or {}
config.colors.tab_bar.background = 'transparent'

-- Set mauve accent color overrides
config.colors.cursor_bg = '#c6a0f6'  -- mauve
config.colors.selection_bg = '#c6a0f6'  -- mauve  
config.colors.selection_fg = '#1e1e2e'  -- base

-- Disable hyperlinks entirely
config.hyperlink_rules = {}

config.status_update_interval = 500

-- Font settings
config.font = wezterm.font('Iosevka Nerd Font')
config.font_size = 16
config.line_height = 1.5

-- Give the tab bar a different font to stand out
config.window_frame = {
  font = wezterm.font({ family = 'Noto Sans', weight = 'Regular' }),
}

-- Set inactive panes to be slightly darker
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- If macOS, set OS_mod to CMD
local os_mod

if is_macos then
  os_mod = 'CMD'
else
  os_mod = 'CTRL|SHIFT'
end

-- Key bindings
config.keys = {
  {
    key = ',',
    mods = os_mod,
    action = wezterm.action.SpawnCommandInNewWindow({
      cwd = wezterm.home_dir,
      args = { 'nvim', wezterm.config_file },
    }),
  },
  { key = 'r', mods = os_mod, action = wezterm.action.ReloadConfiguration },
  { key = 'n', mods = os_mod, action = wezterm.action.SpawnWindow },
  { key = 't', mods = os_mod, action = wezterm.action.SpawnTab('CurrentPaneDomain') },
  { key = 'q', mods = os_mod, action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  { key = 'w', mods = os_mod, action = wezterm.action.CloseCurrentTab({ confirm = false }) },
  { key = 'LeftArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(1) },
  
  -- Tab switching with number row
  { key = '1', mods = os_mod, action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = os_mod, action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = os_mod, action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = os_mod, action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = os_mod, action = wezterm.action.ActivateTab(4) },
  { key = '6', mods = os_mod, action = wezterm.action.ActivateTab(5) },
  { key = '7', mods = os_mod, action = wezterm.action.ActivateTab(6) },
  { key = '8', mods = os_mod, action = wezterm.action.ActivateTab(7) },
  { key = '9', mods = os_mod, action = wezterm.action.ActivateTab(8) },
  
  -- Tab switching with numpad
  { key = 'Numpad1', mods = os_mod, action = wezterm.action.ActivateTab(0) },
  { key = 'Numpad2', mods = os_mod, action = wezterm.action.ActivateTab(1) },
  { key = 'Numpad3', mods = os_mod, action = wezterm.action.ActivateTab(2) },
  { key = 'Numpad4', mods = os_mod, action = wezterm.action.ActivateTab(3) },
  { key = 'Numpad5', mods = os_mod, action = wezterm.action.ActivateTab(4) },
  { key = 'Numpad6', mods = os_mod, action = wezterm.action.ActivateTab(5) },
  { key = 'Numpad7', mods = os_mod, action = wezterm.action.ActivateTab(6) },
  { key = 'Numpad8', mods = os_mod, action = wezterm.action.ActivateTab(7) },
  { key = 'Numpad9', mods = os_mod, action = wezterm.action.ActivateTab(8) },
  { key = 'h', mods = os_mod, action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
  { key = '|', mods = os_mod, action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },

  -- Enable vi like scrolling of scrollback buffer
  { key = 'b', mods = os_mod, action = wezterm.action.ActivateCopyMode },

  -- Enable pop-out terminal to the right
  {
    key = 'F12',
    action = wezterm.action_callback(function(_, pane)
      local tab = pane:tab()
      local panes = tab:panes_with_info()
      if #panes == 1 then
        pane:split({
          direction = 'Right',
          size = 0.4,
        })
      elseif not panes[1].is_zoomed then
        panes[1].pane:activate()
        tab:set_zoomed(true)
      elseif panes[1].is_zoomed then
        tab:set_zoomed(false)
        panes[2].pane:activate()
      end
    end),
  },
}

-- Initialize plugins
require('plugins/tabline')

-- Return the configuration to wezterm
return config
