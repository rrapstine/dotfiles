-- =============================================================================
-- WezTerm Configuration Helpers
-- =============================================================================
-- Utility functions and platform detection for WezTerm configuration
-- =============================================================================

local wezterm = require('wezterm')

-- Platform Detection
-- ------------------

-- Check if current OS is MacOS
local is_macos = wezterm.target_triple:find('apple%-darwin')

-- Modifier Key Logic
-- ------------------

-- Determine the appropriate modifier key based on the platform
-- On macOS, use CMD as the primary modifier
-- On other platforms, use CTRL|SHIFT
local function get_os_modifier()
  if is_macos then
    return 'CMD'
  else
    return 'CTRL|SHIFT'
  end
end

-- Export Functions
-- ----------------

return {
  is_macos = is_macos,
  get_os_modifier = get_os_modifier,
}