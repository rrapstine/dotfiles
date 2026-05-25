--- Window Rules Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

--- Workspace Rules ---
hl.workspace_rule({ workspace = '1', gaps_out = 5, gaps_in = 3, persistent = true })
hl.workspace_rule({ workspace = '2', gaps_out = 5, gaps_in = 3, persistent = true })
hl.workspace_rule({ workspace = '3', gaps_out = 5, gaps_in = 3, persistent = true })
hl.workspace_rule({ workspace = '4', gaps_out = 5, gaps_in = 3, persistent = true })
hl.workspace_rule({ workspace = '5', gaps_out = 5, gaps_in = 3, persistent = true })
hl.workspace_rule({ workspace = '6', gaps_out = 5, gaps_in = 3, persistent = true })

--- Workspace Assignments ---
hl.window_rule({
  match = { class = 'app.zen_browser.zen' },
  workspace = '1',
  maximize = true,
})

hl.window_rule({
  match = { class = 'com.mitchellh.ghostty' },
  workspace = '2',
  maximize = true,
})

hl.window_rule({
  match = { class = 'kitty' },
  workspace = '2',
  maximize = true,
})

hl.window_rule({
  match = { class = 'org.wezfurlong.wezterm' },
  workspace = '2',
  maximize = true,
})

hl.window_rule({
  match = { class = 'steam' },
  workspace = '3',
  maximize = true,
})

hl.window_rule({
  match = { class = 'lutris' },
  workspace = '3',
  maximize = true,
})

hl.window_rule({
  match = { class = 'heroic' },
  workspace = '3',
  maximize = true,
})

hl.window_rule({
  match = { class = 'faugus-launcher' },
  workspace = '3',
  maximize = true,
})

hl.window_rule({
  match = { class = 'vesktop' },
  workspace = '4',
  maximize = true,
})

hl.window_rule({
  match = { class = 'Spotify' },
  workspace = '10',
  maximize = true,
})

--- Float Windows ---
hl.window_rule({
  match = { class = 'org.pulseaudio.pavucontrol' },
  float = true,
})

hl.window_rule({
  match = { title = 'Picture in picture' },
  float = true,
})

hl.window_rule({
  match = { title = 'Save File' },
  float = true,
})

hl.window_rule({
  match = { title = 'Open File' },
  float = true,
})

hl.window_rule({
  match = { class = 'LibreWolf', title = 'Picture-in-Picture' },
  float = true,
})

hl.window_rule({
  match = { class = 'blueman-manager' },
  float = true,
})

hl.window_rule({
  match = { class = 'xdg-desktop-portal-gtk' },
  float = true,
})

hl.window_rule({
  match = { class = 'xdg-desktop-portal-kde' },
  float = true,
})

hl.window_rule({
  match = { class = 'xdg-desktop-portal-hyprland' },
  float = true,
})

hl.window_rule({
  match = { class = 'polkit-gnome-authentication-agent-1' },
  float = true,
})

hl.window_rule({
  match = { class = 'hyprpolkitagent' },
  float = true,
})

hl.window_rule({
  match = { class = 'org.org.kde.polkit-kde-authentication-agent-1' },
  float = true,
})

hl.window_rule({
  match = { class = 'CachyOSHello' },
  float = true,
})

hl.window_rule({
  match = { class = 'zenity' },
  float = true,
})

hl.window_rule({
  match = { title = 'Steam - Self Updater' },
  float = true,
})

--- Opacity ---
hl.window_rule({
  match = { class = 'thunar' },
  opacity = 0.92,
})

hl.window_rule({
  match = { class = 'nemo' },
  opacity = 0.92,
})

hl.window_rule({
  match = { class = 'discord' },
  opacity = 0.96,
})

hl.window_rule({
  match = { class = 'armcord' },
  opacity = 0.96,
})

hl.window_rule({
  match = { class = 'webcord' },
  opacity = 0.96,
})

hl.window_rule({
  match = { title = 'QQ' },
  opacity = 0.95,
})

hl.window_rule({
  match = { title = 'Telegram' },
  opacity = 0.95,
})

hl.window_rule({
  match = { title = 'NetEase Cloud Music Gtk4' },
  opacity = 0.95,
})

--- Float with Size ---
hl.window_rule({
  match = { title = 'Picture-in-Picture' },
  float = true,
  size = { 960, 540 },
})

hl.window_rule({
  match = { title = 'imv' },
  float = true,
  size = { 960, 540 },
})

hl.window_rule({
  match = { title = 'mpv' },
  float = true,
})

hl.window_rule({
  match = { title = 'danmufloat' },
  float = true,
  pin = true,
  size = { 960, 540 },
})

hl.window_rule({
  match = { title = 'termfloat' },
  float = true,
  size = { 960, 540 },
})

hl.window_rule({
  match = { title = 'nemo' },
  float = true,
  size = { 960, 540 },
})

hl.window_rule({
  match = { title = 'ncmpcpp' },
  float = true,
  size = { 960, 540 },
})

--- Rounding ---
hl.window_rule({
  match = { title = 'danmufloat' },
  rounding = 5,
})

hl.window_rule({
  match = { title = 'termfloat' },
  rounding = 5,
})

--- Animations ---
hl.window_rule({
  match = { class = 'kitty' },
  animation = 'slide right',
})

hl.window_rule({
  match = { class = 'Alacritty' },
  animation = 'slide right',
})

--- Blur ---
hl.window_rule({
  match = { class = 'org.mozilla.firefox' },
  no_blur = true,
})

--- Border Styles for Floating/Tiling Windows ---
for i = 1, 10 do
  hl.window_rule({
    match = { float = true, workspace = 'w' .. i },
    border_size = 2,
    border_color = 'rgba(89b4faff)',
    rounding = 8,
  })

  hl.window_rule({
    match = { float = false, workspace = 'f' .. i },
    border_size = 3,
    rounding = 4,
  })
end

--- Layer Rules ---
hl.layer_rule({
  match = { namespace = 'logout_dialog' },
  animation = 'slide top',
})

hl.layer_rule({
  match = { namespace = 'wallpaper' },
  animation = 'fade 50%',
})

