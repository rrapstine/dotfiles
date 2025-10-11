-- =============================================================================
-- WezTerm Keybindings Configuration
-- =============================================================================
-- All keyboard shortcuts and action definitions
-- =============================================================================

local wezterm = require('wezterm')
local helpers = require('utils.helpers')

local function apply_keybindings_config(config)
  -- Modifier Key Setup
  ------------------

  local os_mod = helpers.get_os_modifier()

  -- Window Management
  -----------------

  local window_keys = {
    -- Spawn new window
    { key = 'n', mods = os_mod, action = wezterm.action.SpawnWindow },
    
    -- Edit config file
    {
      key = ',',
      mods = os_mod,
      action = wezterm.action.SpawnCommandInNewWindow({
        cwd = wezterm.home_dir,
        args = { 'nvim', wezterm.config_file },
      }),
    },
  }

  -- Tab Management
  --------------

  local tab_keys = {
    -- Spawn new tab
    { key = 't', mods = os_mod, action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    
    -- Close current tab
    { key = 'w', mods = os_mod, action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    
    -- Navigate tabs with arrow keys
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
  }

  -- Pane Management
  ---------------

  local pane_keys = {
    -- Close current pane
    { key = 'q', mods = os_mod, action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    
    -- Split panes
    { key = 'h', mods = os_mod, action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '|', mods = os_mod, action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
  }

  -- Session Management (Future tmux-like functionality)
  --------------------------------------------------

  local session_keys = {
    -- Placeholder for future session management keybindings
    -- This section will be expanded when implementing tmux-like features
  }

  -- Utility Keybindings
  -------------------

  local utility_keys = {
    -- Reload configuration
    { key = 'r', mods = os_mod, action = wezterm.action.ReloadConfiguration },
    
    -- Enable vi like scrolling of scrollback buffer
    { key = 'b', mods = os_mod, action = wezterm.action.ActivateCopyMode },
  }

  -- Advanced Keybindings
  --------------------

  local advanced_keys = {
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

  -- Combine all keybindings
  -----------------------

  local function combine_key_tables(...)
    local combined = {}
    for _, key_table in ipairs({...}) do
      for _, key in ipairs(key_table) do
        table.insert(combined, key)
      end
    end
    return combined
  end

  config.keys = combine_key_tables(
    window_keys,
    tab_keys,
    pane_keys,
    session_keys,
    utility_keys,
    advanced_keys
  )

  return config
end

return apply_keybindings_config