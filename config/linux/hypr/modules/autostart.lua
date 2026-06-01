--- Autostart Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

local defaults = require('modules.defaults')

hl.on('hyprland.start', function()
  -- Input methods
  hl.exec_cmd('fcitx5 -d &')

  -- Status bar
  hl.exec_cmd('wayle panel start &')

  -- System tray
  -- hl.exec_cmd("nm-applet --indicator &")

  -- Polkit
  hl.exec_cmd('systemctl --user start hyprpolkitagent &')

  -- Launcher services
  hl.exec_cmd('elephant &')
  hl.exec_cmd('walker --gapplication-service &')

  -- Lock screen immediately on startup (works with greetd autologin)
  hl.exec_cmd('hyprlock &')

  -- DBus session
  hl.exec_cmd('systemctl --user import-environment &')
  hl.exec_cmd('hash dbus-update-activation-environment 2>/dev/null &')
  hl.exec_cmd('dbus-update-activation-environment --systemd &')

  -- Idle handler
  hl.exec_cmd(defaults.idlehandler .. ' &')
end)
