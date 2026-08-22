--- Autostart Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local defaults = require('modules.defaults')

hl.on('hyprland.start', function()
  -- Input methods
  hl.exec_cmd('fcitx5 -d &')

  hl.exec_cmd('noctalia')

  -- Polkit
  hl.exec_cmd('systemctl --user start hyprpolkitagent &')

  -- Lock screen immediately on startup (works with greetd autologin)
  hl.exec_cmd('hyprlock &')

  -- DBus session
  hl.exec_cmd('systemctl --user import-environment &')
  hl.exec_cmd('hash dbus-update-activation-environment 2>/dev/null &')
  hl.exec_cmd('dbus-update-activation-environment --systemd &')

  -- Idle handler
  hl.exec_cmd(defaults.idlehandler .. ' &')

  -- Update tmux global environment with the current Hyprland signature
  hl.exec_cmd('tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE "' .. os.getenv('HYPRLAND_INSTANCE_SIGNATURE') .. '"')

  -- Optional: Also update WAYLAND_DISPLAY if needed
  hl.exec_cmd('tmux setenv -g WAYLAND_DISPLAY "' .. os.getenv('WAYLAND_DISPLAY') .. '"')
end)
