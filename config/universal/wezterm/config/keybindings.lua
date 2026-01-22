local wezterm = require('wezterm')

local platform = require('config.platform')
local sessions = require('config.sessions')

local M = {}

function M.apply(config, wezterm)
  local os_mod = platform.os_mod

  config.leader = { key = '`', mods = 'NONE', timeout_milliseconds = 1000 }

  config.keys = {
    {
      key = 'p',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        sessions.show_project_picker(window, pane)
      end),
    },
    {
      key = 's',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        sessions.show_workspace_switcher(window, pane)
      end),
    },
    { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    { key = 'd', mods = 'LEADER', action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },
    { key = '`', mods = 'LEADER', action = wezterm.action.SendKey({ key = '`' }) },
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
    { key = 'q', mods = os_mod, action = wezterm.action.QuitApplication },
    { key = 'LeftArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(1) },
    { key = 'h', mods = os_mod, action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '|', mods = os_mod, action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = 'b', mods = os_mod, action = wezterm.action.ActivateCopyMode },
    {
      key = 'F12',
      action = wezterm.action_callback(function(_, pane)
        local tab = pane:tab()
        local panes = tab:panes_with_info()
        if #panes == 1 then
          pane:split({ direction = 'Right', size = 0.4 })
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
end

return M
