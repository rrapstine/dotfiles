--- Monitor Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
  output = 'HDMI-A-1',
  mode = '3440x1440@99.98',
  position = 'auto',
  scale = 1,
})

hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')
