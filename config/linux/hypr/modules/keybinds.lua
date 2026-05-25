local defaults = require('modules.defaults')
local mainMod = defaults.mainMod

--- Core Applications ---
hl.bind(mainMod .. ' + RETURN', hl.dsp.exec_cmd(defaults.terminal))
hl.bind(mainMod .. ' + E', hl.dsp.exec_cmd(defaults.filemanager))
hl.bind(mainMod .. ' + B', hl.dsp.exec_cmd(defaults.browser))
hl.bind(mainMod .. ' + SPACE', hl.dsp.exec_cmd(defaults.applauncher))
hl.bind(mainMod .. ' + SHIFT + RETURN', hl.dsp.exec_cmd(defaults.terminal .. ' --class=\'ghostty -float\''))

--- Window Operations ---
hl.bind(mainMod .. ' + Q', hl.dsp.window.close())
hl.bind(mainMod .. ' + SHIFT + M', hl.dsp.exec_cmd('loginctl terminate-user ""'))
hl.bind(mainMod .. ' + V', hl.dsp.window.float({ action = 'toggle' }))
hl.bind(mainMod .. ' + F', hl.dsp.window.fullscreen())
hl.bind(mainMod .. ' + Y', hl.dsp.window.pin())
hl.bind(mainMod .. ' + J', hl.dsp.layout('togglesplit'))

--- Groups ---
hl.bind(mainMod .. ' + K', hl.dsp.group.toggle())

--- Launcher ---
hl.bind(mainMod .. ' + Tab', hl.dsp.exec_cmd('walker -m windows'))

--- Gaps ---
hl.bind(mainMod .. ' + SHIFT + G', hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"'))
hl.bind(mainMod .. ' + G', hl.dsp.exec_cmd('hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"'))

--- System ---
hl.bind(mainMod .. ' + L', hl.dsp.exec_cmd('hyprlock --grace 5'))

--- Media Keys ---
hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_cmd('pactl set-sink-volume @DEFAULT_SINK@ +5%'), { repeating = true })
hl.bind('XF86AudioLowerVolume', hl.dsp.exec_cmd('pactl set-sink-volume @DEFAULT_SINK@ -5%'), { repeating = true })
hl.bind('XF86AudioMute', hl.dsp.exec_cmd('pactl set-sink-mute @DEFAULT_SINK@ toggle'), { locked = true })

hl.bind('XF86AudioPlay', hl.dsp.exec_cmd('playerctl --player=spotify play-pause || playerctl play-pause'), { locked = true })
hl.bind('XF86AudioNext', hl.dsp.exec_cmd('playerctl --player=spotify next || playerctl next'), { locked = true })
hl.bind('XF86AudioPrev', hl.dsp.exec_cmd('playerctl --player=spotify previous || playerctl previous'), { locked = true })

hl.bind(mainMod .. ' + XF86AudioPlay', hl.dsp.exec_cmd('hyprctl dispatch workspace 10 && spotify'))

--- Screen Brightness ---
hl.bind('XF86MonBrightnessUp', hl.dsp.exec_cmd('brightnessctl s +5%'), { repeating = true })
hl.bind('XF86MonBrightnessDown', hl.dsp.exec_cmd('brightnessctl s 5%-'), { repeating = true })

--- Window Movement ---
hl.bind(mainMod .. ' + SHIFT + left', hl.dsp.window.move({ direction = 'left' }))
hl.bind(mainMod .. ' + SHIFT + right', hl.dsp.window.move({ direction = 'right' }))
hl.bind(mainMod .. ' + SHIFT + up', hl.dsp.window.move({ direction = 'up' }))
hl.bind(mainMod .. ' + SHIFT + down', hl.dsp.window.move({ direction = 'down' }))
hl.bind(mainMod .. ' + SHIFT + h', hl.dsp.window.move({ direction = 'left' }))
hl.bind(mainMod .. ' + SHIFT + l', hl.dsp.window.move({ direction = 'right' }))
hl.bind(mainMod .. ' + SHIFT + k', hl.dsp.window.move({ direction = 'up' }))
hl.bind(mainMod .. ' + SHIFT + j', hl.dsp.window.move({ direction = 'down' }))

hl.bind(mainMod .. ' + left', hl.dsp.focus({ direction = 'left' }))
hl.bind(mainMod .. ' + right', hl.dsp.focus({ direction = 'right' }))
hl.bind(mainMod .. ' + up', hl.dsp.focus({ direction = 'up' }))
hl.bind(mainMod .. ' + down', hl.dsp.focus({ direction = 'down' }))
hl.bind(mainMod .. ' + h', hl.dsp.focus({ direction = 'left' }))
hl.bind(mainMod .. ' + l', hl.dsp.focus({ direction = 'right' }))
hl.bind(mainMod .. ' + k', hl.dsp.focus({ direction = 'up' }))
hl.bind(mainMod .. ' + j', hl.dsp.focus({ direction = 'down' }))

hl.bind(mainMod .. ' + mouse:272', hl.dsp.window.drag(), { mouse = true })

--- Window Resize ---
hl.bind(mainMod .. ' + CTRL + SHIFT + right', hl.dsp.window.resize({ x = 15, y = 0 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + left', hl.dsp.window.resize({ x = -15, y = 0 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + up', hl.dsp.window.resize({ x = 0, y = -15 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + down', hl.dsp.window.resize({ x = 0, y = 15 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + l', hl.dsp.window.resize({ x = 15, y = 0 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + h', hl.dsp.window.resize({ x = -15, y = 0 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + k', hl.dsp.window.resize({ x = 0, y = -15 }))
hl.bind(mainMod .. ' + CTRL + SHIFT + j', hl.dsp.window.resize({ x = 0, y = 15 }))

hl.bind(mainMod .. ' + mouse:273', hl.dsp.window.resize(), { mouse = true })

--- Workspace: Move Window ---
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. ' + CTRL + ' .. key, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mainMod .. ' + CTRL + left', hl.dsp.window.move({ workspace = '-1' }))
hl.bind(mainMod .. ' + CTRL + right', hl.dsp.window.move({ workspace = '+1' }))

for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. ' + SHIFT + ' .. key, hl.dsp.window.move({ workspace = i, silent = true }))
end

--- Workspace: Switch ---
for i = 1, 10 do
  local key = i % 10
  hl.bind(mainMod .. ' + ' .. key, hl.dsp.focus({ workspace = i }))
end

hl.bind(mainMod .. ' + PERIOD', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind(mainMod .. ' + COMMA', hl.dsp.focus({ workspace = 'e-1' }))
hl.bind(mainMod .. ' + mouse_up', hl.dsp.focus({ workspace = 'e+1' }))
hl.bind(mainMod .. ' + mouse_down', hl.dsp.focus({ workspace = 'e-1' }))
hl.bind(mainMod .. ' + slash', hl.dsp.focus({ workspace = 'previous' }))

hl.bind(mainMod .. ' + minus', hl.dsp.window.move({ workspace = 'special' }))
hl.bind(mainMod .. ' + equal', hl.dsp.workspace.toggle_special('special'))
hl.bind(mainMod .. ' + F1', hl.dsp.workspace.toggle_special('scratchpad'))
hl.bind(mainMod .. ' + ALT + SHIFT + F1', hl.dsp.window.move({ workspace = 'special:scratchpad', silent = true }))

--- Bind Settings ---
hl.config({
  binds = {
    allow_workspace_cycles = true,
    workspace_back_and_forth = true,
    workspace_center_on = 1,
    movefocus_cycles_fullscreen = true,
    window_direction_monitor_fallback = true,
  },
})

