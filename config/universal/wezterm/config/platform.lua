local wezterm = require('wezterm')
local is_macos = wezterm.target_triple:find('apple%-darwin')

local M = {
  is_macos = is_macos,
  os_mod = is_macos and 'CMD' or 'CTRL|SHIFT',
}

function M.apply(config, wezterm)
  if is_macos then
    config.set_environment_variables = {
      PATH = '/opt/homebrew/bin:' .. os.getenv('PATH'),
    }

    wezterm.on('gui-startup', function()
      local tab, pane, window = wezterm.mux.spawn_window({})
      window:gui_window():maximize()
    end)

    config.macos_window_background_blur = 10
    config.window_decorations = 'RESIZE'
  end
end

return M
