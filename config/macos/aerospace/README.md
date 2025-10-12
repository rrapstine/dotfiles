# AeroSpace Configuration

This is an AeroSpace window manager configuration that closely mimics a Hyprland setup, adapted for macOS conventions.

## Overview

- **Main Modifier**: Alt (Option) key to avoid macOS conflicts
- **Workspaces**: 6 named workspaces inspired by Hyprland
- **Layout**: Tiling with gaps matching the original Hyprland config
- **Keybinds**: Vi-style navigation with arrow key alternatives

## Workspaces

| Workspace | Name | Applications | Purpose |
|-----------|------|--------------|---------|
| 1 | Browser | Safari, Firefox, Firefox Dev Edition, Zen Browser | Web browsing |
| 2 | Terminal | Ghostty, WezTerm | Terminal operations |
| 3 | Games | Steam | Gaming applications |
| 4 | Social | Discord, Slack | Communication |
| 5 | Misc | General applications | Miscellaneous apps |
| 6 | Media | Spotify | Media applications |

## Key Bindings

### Application Launchers
- `Alt + Enter`: Open new Ghostty terminal
- `Alt + B`: Open Safari browser
- `Alt + F`: Open Finder

### Window Management
- `Alt + Q`: Close window
- `Alt + F`: Toggle fullscreen
- `Alt + Space`: Toggle floating/tiling

### Navigation
- `Alt + H/J/K/L` or `Alt + Arrow Keys`: Focus windows
- `Alt + Shift + H/J/K/L` or `Alt + Shift + Arrow Keys`: Move windows

### Workspaces
- `Alt + 1-6`: Switch to workspace
- `Alt + Shift + 1-6`: Move window to workspace
- `Alt + Ctrl + 1-6`: Move window to workspace and follow
- `Alt + Tab`: Workspace back-and-forth
- `Alt + ,/.`: Previous/Next workspace

### Layouts
- `Alt + E`: Tiles layout
- `Alt + S`: Vertical accordion (stacking)
- `Alt + W`: Horizontal accordion (tabbed)

### Resizing
- `Alt + -/+`: Resize smart
- `Alt + R`: Enter resize mode
  - In resize mode: `H/J/K/L` or arrows to resize, `Enter/Esc` to exit

### Service Mode
- `Alt + Shift + ;`: Enter service mode
  - `Esc`: Reload config and exit
  - `R`: Flatten workspace tree
  - `F`: Toggle floating/tiling
  - `T`: Tiles layout
  - `A`: Accordion layout

## Application Assignments

Applications are automatically assigned to their designated workspaces:

### Browsers (Workspace 1)
- Safari (`com.apple.Safari`)
- Firefox (`org.mozilla.firefox`)
- Firefox Developer Edition (`org.mozilla.firefoxdeveloperedition`)
- Zen Browser (`app.zen-browser.zen`)

### Terminals (Workspace 2)
- Ghostty (`com.mitchellh.ghostty`)
- WezTerm (`com.github.wez.wezterm`)

### Games (Workspace 3)
- Steam (`com.valvesoftware.steam`)

### Social (Workspace 4)
- Discord (`com.hnc.Discord`)
- Slack (`com.tinyspeck.slackmacgap`)

### Media (Workspace 6)
- Spotify (`com.spotify.client`)

## Floating Windows

The following applications and window types automatically float:
- System Preferences
- Activity Monitor
- Picture-in-Picture windows
- Save/Open file dialogs

## Multi-Monitor Setup

The configuration includes workspace-to-monitor assignments:
- Workspaces 1, 2, 4, 5, 6: Main monitor
- Workspace 3: Secondary monitor (if available)

## Installation

1. Install AeroSpace via Homebrew:
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```

2. Copy the configuration to AeroSpace's config location:
   ```bash
   cp ~/.config/dotfiles/config/macos/aerospace/aerospace.toml ~/.aerospace.toml
   ```

3. Restart AeroSpace or reload the configuration:
   ```bash
   aerospace reload-config
   ```

## Configuration Structure

While AeroSpace doesn't natively support modular configs, this file is organized with clear sections:
- Main configuration
- Workspace assignments
- Window rules
- Key bindings
- Binding modes

## Differences from Hyprland

- **Modifier**: Alt instead of Super to avoid macOS conflicts
- **Workspaces**: 6 instead of 10 (no intermediate workspaces needed)
- **Special workspaces**: Not directly supported in AeroSpace
- **Window opacity**: Not supported in AeroSpace
- **Animations**: Not applicable to AeroSpace

## Troubleshooting

If applications don't move to their assigned workspaces:
1. Check the application ID with `aerospace list-apps`
2. Verify the app ID in the window rules section
3. Reload the configuration with `Alt + Shift + ;` then `Esc`

For more information, see the [AeroSpace Guide](https://nikitabobko.github.io/AeroSpace/guide).