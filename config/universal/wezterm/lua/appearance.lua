-- =============================================================================
-- WezTerm Appearance Configuration
-- =============================================================================
-- Visual settings including colors, fonts, window, and tab bar configuration
-- =============================================================================

local wezterm = require('wezterm')
local helpers = require('utils.helpers')

local function apply_appearance_config(config)
  -- Color Scheme & Custom Colors
  ----------------------------

  -- Set the color scheme
  config.color_scheme = 'catppuccin-mocha'

  -- Set mauve accent color overrides
  config.colors = config.colors or {}
  config.colors.cursor_bg = '#c6a0f6' -- mauve
  config.colors.selection_bg = '#c6a0f6' -- mauve
  config.colors.selection_fg = '#1e1e2e' -- base

  -- Font Configuration
  -------------------

  config.font = wezterm.font('Iosevka Nerd Font')
  config.font_size = 16
  config.line_height = 1.5

  -- Give the tab bar a different font to stand out
  config.window_frame = {
    font = wezterm.font({ family = 'Noto Sans', weight = 'Regular' }),
  }

  -- Window Settings
  ---------------

  -- Smoother animation
  config.max_fps = 120

  -- Window padding
  config.window_padding = config.window_padding or {}
  config.window_padding.left = 4
  config.window_padding.right = 4
  config.window_padding.top = 4
  config.window_padding.bottom = 4

  -- Set inactive panes to be slightly darker
  config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  }

  -- Tab Bar Configuration
  ---------------------

  config.hide_tab_bar_if_only_one_tab = false
  config.show_new_tab_button_in_tab_bar = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.tab_max_width = 32

  config.colors.tab_bar = config.colors.tab_bar or {}
  config.colors.tab_bar.background = 'transparent'

  -- Platform-Specific Appearance
  ----------------------------

  -- macOS-specific appearance settings
  if helpers.is_macos then
    -- Set blur on macOS
    config.macos_window_background_blur = 10

    -- Remove window decorations on macOS
    -- This is needed because setting this universally breaks things on Hyprland
    config.window_decorations = 'RESIZE'
  end

  -- Disable hyperlinks entirely
  config.hyperlink_rules = {}

  config.status_update_interval = 500

  return config
end

return apply_appearance_config

