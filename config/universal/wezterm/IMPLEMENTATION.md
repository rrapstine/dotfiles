# Detailed Implementation Plan: WezTerm tmux Replacement

## Overview

Transform the current single-file wezterm config into a modular, tmux-like session management system with:
- Project picker that scans `~/Code` for git repositories
- Persistent workspaces via mux server
- Leader key (backtick) based keybindings
- Custom tab titles showing `PROJECT_NAME | PROCESS_NAME`

---

## File Structure

```
~/Code/dotfiles/config/universal/wezterm/
├── wezterm.lua              # Slim entry point (~30 lines)
├── config/
│   ├── appearance.lua       # Visual settings (~60 lines)
│   ├── keybindings.lua      # All key mappings (~120 lines)
│   ├── platform.lua         # OS-specific settings (~40 lines)
│   └── sessions.lua         # Project/workspace management (~150 lines)
└── plugins/
    └── tabline.lua          # Tab bar configuration (~60 lines)
```

---

## Module 1: `config/platform.lua`

### Purpose
Detect the operating system and export platform-specific settings that other modules depend on.

### Exports
```lua
return {
  is_macos = boolean,      -- true if running on macOS
  os_mod = string,         -- "CMD" on macOS, "CTRL|SHIFT" on Linux
  apply = function(config, wezterm)  -- applies platform-specific config
}
```

### Implementation Details

**Detection logic:**
```lua
local is_macos = wezterm.target_triple:find('apple%-darwin') ~= nil
```

**`apply(config, wezterm)` function will:**

1. **If macOS:**
   - Set `config.set_environment_variables.PATH` to include `/opt/homebrew/bin`
   - Set `config.macos_window_background_blur = 10`
   - Set `config.window_decorations = 'RESIZE'`
   - Register `gui-startup` event to maximize window on startup

2. **Both platforms:**
   - No additional shared platform logic currently needed

### Expected Outcome
- Other modules can `require('config.platform')` and access `is_macos` and `os_mod`
- Platform-specific settings are applied cleanly without polluting other modules

---

## Module 2: `config/appearance.lua`

### Purpose
Centralize all visual/aesthetic configuration: colors, fonts, window padding, tab bar base settings.

### Exports
```lua
return {
  apply = function(config, wezterm)  -- applies all appearance settings
}
```

### Implementation Details

**`apply(config, wezterm)` function will set:**

1. **Color scheme:**
   ```lua
   config.color_scheme = 'catppuccin-mocha'
   config.colors = {
     tab_bar = { background = 'transparent' },
     cursor_bg = '#c6a0f6',      -- mauve
     selection_bg = '#c6a0f6',   -- mauve
     selection_fg = '#1e1e2e',   -- base
   }
   ```

2. **Font settings:**
   ```lua
   config.font = wezterm.font('Iosevka Nerd Font')
   config.font_size = 16
   config.line_height = 1.5
   config.window_frame = {
     font = wezterm.font({ family = 'Noto Sans', weight = 'Regular' }),
   }
   ```

3. **Window settings:**
   ```lua
   config.max_fps = 120
   config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }
   ```

4. **Tab bar settings:**
   ```lua
   config.hide_tab_bar_if_only_one_tab = false
   config.show_new_tab_button_in_tab_bar = false
   config.use_fancy_tab_bar = false
   config.tab_bar_at_bottom = true
   config.tab_max_width = 32
   config.status_update_interval = 500
   ```

5. **Pane settings:**
   ```lua
   config.inactive_pane_hsb = { saturation = 0.8, brightness = 0.7 }
   ```

6. **Misc:**
   ```lua
   config.hyperlink_rules = {}  -- disable hyperlinks
   ```

### Expected Outcome
- All visual settings consolidated in one place
- Easy to modify colors/fonts without touching other logic
- Config looks identical to current setup after this module is applied

---

## Module 3: `config/sessions.lua`

### Purpose
Core session management: scan for projects, create workspaces with predefined tabs, provide picker interfaces.

### Exports
```lua
return {
  setup = function(wezterm)           -- stores wezterm reference
  scan_projects = function()          -- returns list of {name, path}
  show_project_picker = function(window, pane)     -- InputSelector for projects
  show_workspace_switcher = function(window, pane) -- InputSelector for workspaces
}
```

### Implementation Details

#### `scan_projects()`

**Algorithm:**
1. Initialize empty `projects` table
2. Scan `~/Code/projects/`:
   - For each subdirectory, check if `.git` exists
   - If yes, add `{name = dirname, path = full_path}` to projects
3. Check `~/Code/dotfiles`:
   - If `.git` exists, add `{name = 'dotfiles', path = '~/Code/dotfiles'}`
4. Sort projects alphabetically by name
5. Return projects table

**Implementation:**
```lua
local function scan_projects()
  local projects = {}
  local home = wezterm.home_dir
  
  -- Scan ~/Code/projects/*
  local projects_dir = home .. '/Code/projects'
  local success, entries = pcall(wezterm.read_dir, projects_dir)
  if success then
    for _, entry in ipairs(entries) do
      local git_dir = entry .. '/.git'
      local git_check = io.open(git_dir, 'r')
      if git_check then
        git_check:close()
        local name = entry:match('([^/]+)$')  -- extract dirname
        table.insert(projects, { name = name, path = entry })
      end
    end
  end
  
  -- Check ~/Code/dotfiles
  local dotfiles = home .. '/Code/dotfiles'
  local git_check = io.open(dotfiles .. '/.git', 'r')
  if git_check then
    git_check:close()
    table.insert(projects, { name = 'dotfiles', path = dotfiles })
  end
  
  -- Sort alphabetically
  table.sort(projects, function(a, b) return a.name < b.name end)
  
  return projects
end
```

#### `create_workspace(window, name, path)`

**Called when:** User selects a project that doesn't have an existing workspace

**Steps:**
1. Spawn new window in workspace named `name` with cwd `path`
2. First tab runs `nvim` (this is the initial spawn)
3. Spawn second tab running `opencode`
4. Spawn third tab with default shell
5. Activate first tab (nvim)

**Implementation:**
```lua
local function create_workspace(window, name, path)
  local mux_window = window:mux_window()
  
  -- Spawn first tab with nvim in new workspace
  local tab1, pane1, new_window = mux_window:spawn_tab({
    workspace = name,
    cwd = path,
    args = { 'nvim' },
  })
  
  -- Get the new mux window (workspace creates a new window)
  local mux = wezterm.mux
  for _, w in ipairs(mux.all_windows()) do
    if w:get_workspace() == name then
      new_window = w
      break
    end
  end
  
  -- Spawn second tab with opencode
  new_window:spawn_tab({
    cwd = path,
    args = { 'opencode' },
  })
  
  -- Spawn third tab with shell (no args = default shell)
  new_window:spawn_tab({
    cwd = path,
  })
  
  -- Activate first tab
  new_window:tabs()[1]:activate()
  
  -- Switch to the new workspace
  mux.set_active_workspace(name)
end
```

#### `show_project_picker(window, pane)`

**Called when:** User presses `` ` + p ``

**Behavior:**
1. Call `scan_projects()` to get fresh project list
2. Build choices array for InputSelector:
   - Each choice: `{id = path, label = name}`
3. Display InputSelector with fuzzy search enabled
4. On selection:
   - Check if workspace with that name already exists
   - If yes: switch to it via `SwitchToWorkspace`
   - If no: call `create_workspace()`

**Implementation:**
```lua
local function show_project_picker(window, pane)
  local projects = scan_projects()
  local choices = {}
  
  for _, project in ipairs(projects) do
    table.insert(choices, {
      id = project.path,
      label = project.name,
    })
  end
  
  window:perform_action(
    wezterm.action.InputSelector({
      title = 'Select Project',
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id then return end  -- user cancelled
        
        -- Check if workspace exists
        local workspaces = wezterm.mux.get_workspace_names()
        local exists = false
        for _, ws in ipairs(workspaces) do
          if ws == label then
            exists = true
            break
          end
        end
        
        if exists then
          -- Switch to existing workspace
          inner_window:perform_action(
            wezterm.action.SwitchToWorkspace({ name = label }),
            inner_pane
          )
        else
          -- Create new workspace
          create_workspace(inner_window, label, id)
        end
      end),
    }),
    pane
  )
end
```

#### `show_workspace_switcher(window, pane)`

**Called when:** User presses `` ` + s ``

**Behavior:**
1. Get list of existing workspaces via `wezterm.mux.get_workspace_names()`
2. Build choices array (name only, no path needed)
3. Display InputSelector with fuzzy search
4. On selection: switch to workspace via `SwitchToWorkspace`

**Implementation:**
```lua
local function show_workspace_switcher(window, pane)
  local workspaces = wezterm.mux.get_workspace_names()
  local choices = {}
  
  for _, name in ipairs(workspaces) do
    table.insert(choices, {
      id = name,
      label = name,
    })
  end
  
  window:perform_action(
    wezterm.action.InputSelector({
      title = 'Switch Workspace',
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id then return end
        inner_window:perform_action(
          wezterm.action.SwitchToWorkspace({ name = id }),
          inner_pane
        )
      end),
    }),
    pane
  )
end
```

#### `setup(wezterm)`

**Purpose:** Store wezterm reference for use by other functions in module

```lua
local M = {}
local wezterm

function M.setup(wez)
  wezterm = wez
end
```

### Expected Outcome
- `` ` + p `` opens fuzzy project picker showing project names only (not full paths)
- Selecting a project either switches to existing workspace or creates new one with 3 tabs
- `` ` + s `` opens fuzzy workspace switcher for quick switching between active sessions
- Workspaces persist across window closes due to mux server

---

## Module 4: `config/keybindings.lua`

### Purpose
Define all keybindings: leader key, tmux-like bindings, platform-aware bindings, and the F12 toggle.

### Exports
```lua
return {
  apply = function(config, wezterm)  -- applies all keybindings
}
```

### Implementation Details

#### Leader Key Configuration
```lua
config.leader = { key = '`', mods = 'NONE', timeout_milliseconds = 1000 }
```

#### Keybindings Table

**Leader-based bindings (`` ` `` prefix):**

| Key | Action | Implementation |
|-----|--------|----------------|
| `` ` + p `` | Project picker | `action_callback` -> `sessions.show_project_picker` |
| `` ` + s `` | Workspace switcher | `action_callback` -> `sessions.show_workspace_switcher` |
| `` ` + c `` | New tab | `SpawnTab('CurrentPaneDomain')` |
| `` ` + x `` | Close tab | `CloseCurrentTab({ confirm = false })` |
| `` ` + w `` | Close pane | `CloseCurrentPane({ confirm = false })` |
| `` ` + d `` | Detach (close window) | `CloseCurrentTab` on all tabs OR `QuitApplication` for just window |
| `` ` + 1 `` | Tab 1 | `ActivateTab(0)` |
| `` ` + 2 `` | Tab 2 | `ActivateTab(1)` |
| `` ` + 3 `` | Tab 3 | `ActivateTab(2)` |
| `` ` + 4 `` | Tab 4 | `ActivateTab(3)` |
| `` ` + 5 `` | Tab 5 | `ActivateTab(4)` |
| `` ` + 6 `` | Tab 6 | `ActivateTab(5)` |
| `` ` + 7 `` | Tab 7 | `ActivateTab(6)` |
| `` ` + 8 `` | Tab 8 | `ActivateTab(7)` |
| `` ` + 9 `` | Tab 9 | `ActivateTab(8)` |
| `` ` + ` `` | Literal backtick | `SendKey({ key = '\`' })` |

**Platform-aware bindings (CMD on macOS / CTRL+SHIFT on Linux):**

| Key | Action | Implementation |
|-----|--------|----------------|
| `,` | Open config in nvim | `SpawnCommandInNewWindow({ args = {'nvim', config_file} })` |
| `r` | Reload config | `ReloadConfiguration` |
| `n` | New window | `SpawnWindow` |
| `t` | New tab | `SpawnTab('CurrentPaneDomain')` |
| `q` | Quit wezterm | `QuitApplication` |
| `LeftArrow` | Previous tab | `ActivateTabRelative(-1)` |
| `RightArrow` | Next tab | `ActivateTabRelative(1)` |
| `h` | Split horizontal | `SplitHorizontal({ domain = 'CurrentPaneDomain' })` |
| `\|` | Split vertical | `SplitVertical({ domain = 'CurrentPaneDomain' })` |
| `b` | Copy mode | `ActivateCopyMode` |

**Standalone bindings:**

| Key | Action | Implementation |
|-----|--------|----------------|
| `F12` | Pop-out toggle | `action_callback` (existing logic from current config) |

#### Full Implementation

```lua
local platform = require('config.platform')
local sessions = require('config.sessions')

local M = {}

function M.apply(config, wezterm)
  local os_mod = platform.os_mod
  
  -- Leader key
  config.leader = { key = '`', mods = 'NONE', timeout_milliseconds = 1000 }
  
  config.keys = {
    -- Leader bindings
    {
      key = 'p',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        sessions.show_project_picker(window, pane)
      end),
    },
    {
      key = 's',
      mods = 'LEADER',
      action = wezterm.action_callback(function(window, pane)
        sessions.show_workspace_switcher(window, pane)
      end),
    },
    { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentPane({ confirm = false }) },
    { key = 'd', mods = 'LEADER', action = wezterm.action.CloseCurrentTab({ confirm = false }) },
    -- Note: `+d closes the window by closing all tabs, mux keeps workspace alive
    
    -- Tab switching (1-indexed for user, 0-indexed internally)
    { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
    { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
    { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
    { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
    { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },
    { key = '6', mods = 'LEADER', action = wezterm.action.ActivateTab(5) },
    { key = '7', mods = 'LEADER', action = wezterm.action.ActivateTab(6) },
    { key = '8', mods = 'LEADER', action = wezterm.action.ActivateTab(7) },
    { key = '9', mods = 'LEADER', action = wezterm.action.ActivateTab(8) },
    
    -- Send literal backtick
    { key = '`', mods = 'LEADER', action = wezterm.action.SendKey({ key = '`' }) },
    
    -- Platform-aware bindings
    {
      key = ',',
      mods = os_mod,
      action = wezterm.action.SpawnCommandInNewWindow({
        cwd = wezterm.home_dir,
        args = { 'nvim', wezterm.config_file },
      }),
    },
    { key = 'r', mods = os_mod, action = wezterm.action.ReloadConfiguration },
    { key = 'n', mods = os_mod, action = wezterm.action.SpawnWindow },
    { key = 't', mods = os_mod, action = wezterm.action.SpawnTab('CurrentPaneDomain') },
    { key = 'q', mods = os_mod, action = wezterm.action.QuitApplication },
    { key = 'LeftArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(-1) },
    { key = 'RightArrow', mods = os_mod, action = wezterm.action.ActivateTabRelative(1) },
    { key = 'h', mods = os_mod, action = wezterm.action.SplitHorizontal({ domain = 'CurrentPaneDomain' }) },
    { key = '|', mods = os_mod, action = wezterm.action.SplitVertical({ domain = 'CurrentPaneDomain' }) },
    { key = 'b', mods = os_mod, action = wezterm.action.ActivateCopyMode },
    
    -- F12 pop-out toggle
    {
      key = 'F12',
      action = wezterm.action_callback(function(_, pane)
        local tab = pane:tab()
        local panes = tab:panes_with_info()
        if #panes == 1 then
          pane:split({ direction = 'Right', size = 0.4 })
        elseif not panes[1].is_zoomed then
          panes[1].pane:activate()
          tab:set_zoomed(true)
        elseif panes[1].is_zoomed then
          tab:set_zoomed(false)
          panes[2].pane:activate()
        end
      end),
    },
  }
end

return M
```

### Expected Outcome
- Pressing `` ` `` activates leader mode for 1 second
- All tmux-like bindings work as specified
- Platform-aware bindings use CMD on macOS, CTRL+SHIFT on Linux
- `CMD+q` / `CTRL+SHIFT+q` quits wezterm completely
- Tab numbers 1-9 map to tabs 0-8 internally (user sees 1-indexed)

---

## Module 5: `plugins/tabline.lua`

### Purpose
Configure the tabline plugin to show custom tab titles in format `PROJECT_NAME | PROCESS_NAME`.

### Implementation Details

#### Tab Title Format

The tabline plugin supports custom function components. We'll use a function for `tab_active` and `tab_inactive` that:

1. Gets the current workspace name (= project name)
2. Gets the foreground process name
3. Returns formatted string: `PROJECT_NAME | PROCESS_NAME`

#### Implementation

```lua
local wezterm = require('wezterm')
local tabline = wezterm.plugin.require('https://github.com/michaelbrusegard/tabline.wez')

-- Custom function to get workspace | process format
local function workspace_process(tab)
  local workspace = 'default'
  
  -- Try to get workspace from mux
  local mux_win = tab.window
  if mux_win then
    workspace = mux_win:get_workspace() or 'default'
  end
  
  -- Get process name
  local process = tab.active_pane.foreground_process_name or 'shell'
  process = process:match('([^/]+)$') or process
  
  return workspace .. ' | ' .. process
end

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    tabs_enabled = true,
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
    component_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
    tab_separators = {
      left = wezterm.nerdfonts.ple_right_half_circle_thick,
      right = wezterm.nerdfonts.ple_left_half_circle_thick,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { workspace_process, padding = { left = 1, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = {
      'index',
      { workspace_process, padding = { left = 1, right = 1 } },
    },
    tabline_x = {},
    tabline_y = {},
    tabline_z = {},
  },
  extensions = {},
})
```

### Expected Outcome
- `tabline_b` shows current workspace name (e.g., "my-project")
- Each tab shows: `INDEX  PROJECT_NAME | PROCESS_NAME`
- Example tabs: `1 my-project | nvim`, `2 my-project | opencode`, `3 my-project | zsh`
- Visual style remains consistent with current pill-shaped separators

---

## Module 6: `wezterm.lua` (Entry Point)

### Purpose
Slim entry point that initializes config, loads all modules, and returns the final config.

### Implementation

```lua
-- Pull in the wezterm API
local wezterm = require('wezterm')

-- Initialize config builder
local config = wezterm.config_builder()

-- Load and apply modules
local platform = require('config.platform')
local appearance = require('config.appearance')
local keybindings = require('config.keybindings')
local sessions = require('config.sessions')

-- Setup sessions module (needs wezterm reference)
sessions.setup(wezterm)

-- Apply configurations
platform.apply(config, wezterm)
appearance.apply(config, wezterm)
keybindings.apply(config, wezterm)

-- Mux server configuration for session persistence
config.unix_domains = {
  { name = 'unix' },
}
config.default_gui_startup_args = { 'connect', 'unix' }

-- Initialize tabline plugin
require('plugins/tabline')

-- Return the configuration
return config
```

### Expected Outcome
- Clean ~30 line entry point
- All logic delegated to modules
- Mux server enabled for session persistence
- Wezterm automatically connects to mux on startup

---

## Module 7: Mux Server Configuration

### Purpose
Enable session persistence across wezterm restarts.

### Implementation
Added directly in `wezterm.lua`:

```lua
config.unix_domains = {
  { name = 'unix' },
}
config.default_gui_startup_args = { 'connect', 'unix' }
```

### How It Works

1. **First wezterm launch:**
   - Wezterm starts the mux server (unix domain socket)
   - GUI connects to the mux server
   - Default workspace created at `~`

2. **User creates project workspaces:**
   - Each workspace exists in the mux server
   - Tabs/panes are managed by the mux

3. **User closes wezterm window (or uses `` `+d ``):**
   - GUI window closes
   - Mux server continues running in background
   - All workspaces preserved

4. **User reopens wezterm:**
   - `default_gui_startup_args` makes it connect to existing mux
   - All workspaces still there
   - Resumes exactly where left off

5. **Full quit (`CMD+q` / `CTRL+SHIFT+q`):**
   - Quits the entire application including mux server
   - All sessions are lost (this is expected behavior for "quit")

### Expected Outcome
- Opening wezterm connects to existing mux if running
- Closing window preserves all workspaces
- Sessions persist until system restart or explicit quit

---

## Summary: What Changes

### Files Created (4 new files)
1. `config/platform.lua` - OS detection and platform-specific settings
2. `config/appearance.lua` - Visual configuration
3. `config/keybindings.lua` - All key mappings
4. `config/sessions.lua` - Project scanner and workspace management

### Files Modified (2 existing files)
1. `wezterm.lua` - Completely rewritten as slim entry point
2. `plugins/tabline.lua` - Updated with custom tab title format

### Keybindings Added
- Leader key (`` ` ``) with 1 second timeout
- `` ` + p `` - Project picker
- `` ` + s `` - Workspace switcher
- `` ` + c `` - New tab
- `` ` + x `` - Close tab
- `` ` + w `` - Close pane
- `` ` + d `` - Detach (close window)
- `` ` + 1-9 `` - Tab switching (1-indexed)
- `` ` + ` `` - Literal backtick

### Keybindings Removed
- `CMD/CTRL+SHIFT + 1-9` - Tab access (moved to leader)
- `CMD/CTRL+SHIFT + Numpad1-9` - Tab access (removed)
- `CMD/CTRL+SHIFT + w` - Close tab (moved to `` `+x ``)
- `CMD/CTRL+SHIFT + q` - Close pane (now quits app; pane close moved to `` `+w ``)

### Keybindings Changed
- `CMD+q` / `CTRL+SHIFT+q` - Now quits wezterm completely (was close pane)

### New Functionality
- **Project picker**: Scans `~/Code/projects/*` and `~/Code/dotfiles` for git repos
- **Workspace creation**: 3-tab layout (nvim, opencode, shell) per project
- **Workspace switching**: Quick switch between existing sessions
- **Session persistence**: Mux server keeps workspaces alive across window closes

---

## Execution Order

1. Create `config/` directory
2. Create `config/platform.lua`
3. Create `config/appearance.lua`
4. Create `config/sessions.lua`
5. Create `config/keybindings.lua`
6. Update `plugins/tabline.lua`
7. Rewrite `wezterm.lua`
8. Test configuration
