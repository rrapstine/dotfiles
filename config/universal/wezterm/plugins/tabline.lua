local wezterm = require('wezterm')
local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')

local function workspace_process(tab)
  local workspace = 'default'
  
  local mux_win = tab.window
  if mux_win then
    workspace = mux_win:get_workspace() or 'default'
  end
  
  local process = tab.active_pane.foreground_process_name or 'shell'
  process = process:match('([^/]+)$') or process
  
  return workspace .. ' | ' .. process
end

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
    component_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
    tab_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { workspace_process, padding = { left = 1, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = {
      'index',
      { workspace_process, padding = { left = 1, right = 1 } },
    },
    tabline_x = {},
    tabline_y = {},
    tabline_z = {},
  },
  extensions = {},
})
