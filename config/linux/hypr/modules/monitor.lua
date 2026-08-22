--- Monitor Configuration ---
-- https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
  output = 'DP-1',
  mode = '3440x1440@143.97Hz',
  position = 'auto',
  scale = 1,
})

hl.env('ELECTRON_OZONE_PLATFORM_HINT', 'auto')
