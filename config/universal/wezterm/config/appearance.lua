local wezterm = require('wezterm')

local M = {}

function M.apply(config, wezterm)
  config.color_scheme = 'catppuccin-mocha'

  config.colors = {
    tab_bar = { background = 'transparent' },
    cursor_bg = '#c6a0f6',
    selection_bg = '#c6a0f6',
    selection_fg = '#1e1e2e',
  }

  config.font = wezterm.font('Iosevka Nerd Font')
  config.font_size = 16
  config.line_height = 1.5

  config.window_frame = {
    font = wezterm.font({ family = 'Noto Sans', weight = 'Regular' }),
  }

  config.max_fps = 120

  config.window_padding = {
    left = 4,
    right = 4,
    top = 4,
    bottom = 4,
  }

  config.hide_tab_bar_if_only_one_tab = false
  config.show_new_tab_button_in_tab_bar = false
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true
  config.tab_max_width = 32
  config.status_update_interval = 500

  config.inactive_pane_hsb = {
    saturation = 0.8,
    brightness = 0.7,
  }

  config.hyperlink_rules = {}
end

return M
