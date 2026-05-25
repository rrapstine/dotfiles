--- Variables Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Variables/

--- General ---
hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 5,
    border_size = 3,
    col = {
      active_border = 'rgba(cba6f7ff)',
      inactive_border = 'rgba(f5e0dc33)',
    },
    layout = 'dwindle',
    snap = {
      enabled = true,
    },
    resize_on_border = true,
  },
})

--- Groups ---
hl.config({
  group = {
    col = {
      border_active = 'rgba(cba6f7ff)',
      border_inactive = 'rgba(cba6f7ff)',
      border_locked_active = 'rgba(cba6f7ff)',
      border_locked_inactive = 'rgba(f5e0dcff)',
    },
    groupbar = {
      font_family = 'Fira Sans',
      text_color = 'rgba(cdd6f4ff)',
      col = {
        active = 'rgba(cba6f7ff)',
        inactive = 'rgba(f5e0dcff)',
        locked_active = 'rgba(cba6f7ff)',
        locked_inactive = 'rgba(f5e0dcff)',
      },
    },
  },
})

--- Misc ---
hl.config({
  misc = {
    font_family = 'Fira Sans',
    splash_font_family = 'Fira Sans',
    disable_hyprland_logo = true,
    col = {
      splash = 'rgba(cba6f7ff)',
    },
    background_color = 'rgba(f5e0dcff)',
    enable_swallow = true,
    swallow_regex = '^(cachy-browser|firefox|nautilus|nemo|thunar|btrfs-assistant.)$',
    focus_on_activate = true,
    vrr = 2,
  },
})

--- Render ---
hl.config({
  render = {
    direct_scanout = true,
  },
})

--- Dwindle Layout ---
hl.config({
  dwindle = {
    special_scale_factor = 0.8,
    preserve_split = true,
  },
})

--- Master Layout ---
hl.config({
  master = {
    new_status = 'master',
    special_scale_factor = 0.8,
  },
})

--- Gestures ---
hl.gesture({
  fingers = 4,
  direction = 'horizontal',
  action = 'workspace',
})

hl.gesture({
  fingers = 3,
  direction = 'down',
  action = 'close',
})

hl.gesture({
  fingers = 3,
  direction = 'up',
  action = 'fullscreen',
})

hl.gesture({
  fingers = 3,
  direction = 'left',
  action = 'float',
})

