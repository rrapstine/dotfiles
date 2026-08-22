--- Defaults Configuration ---
-- User preferences for programs and system

local defaults = {
  mainMod = 'SUPER',
  terminal = 'ghostty',
  filemanager = 'nautilus',
  browser = 'brave-origin',
  applauncher = 'noctalia msg panel-open launcher',
  idlehandler = 'hypridle',
}

-- mainMod as env var for dynamic keybind string building
hl.env('mainMod', defaults.mainMod)

return defaults
