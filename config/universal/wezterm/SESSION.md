# WezTerm Configuration Session Context

## Project Overview

**Primary Goal**: Replace tmux functionality with WezTerm while maintaining a clean, modular, and maintainable configuration.

**Current Status**: Configuration has been successfully modularized and is ready for implementing tmux-like features. The foundation is solid with proper separation of concerns and established patterns.

## Completed Work

### 1. Modularization (✅ Complete)
- **Before**: Single `wezterm.lua` file (167 lines)
- **After**: Modular structure with 4 main files
  - `wezterm.lua` (56 lines - 66% reduction)
  - `lua/appearance.lua` (86 lines)
  - `lua/keybindings.lua` (152 lines)
  - `lua/utils/helpers.lua` (34 lines)

### 2. Code Refactoring (✅ Complete)
- Applied `wezterm.merge_with` pattern for table initialization
- Replaced verbose patterns like:
  ```lua
  config.colors = config.colors or {}
  config.colors.cursor_bg = '#c6a0f6'
  ```
- With cleaner table literals:
  ```lua
  config.colors = wezterm.merge_with(config.colors or {}, {
    cursor_bg = '#c6a0f6',
  })
  ```

### 3. File Structure Established
```
wezterm/
├── wezterm.lua (main composition)
├── lua/
│   ├── appearance.lua (visual settings)
│   ├── keybindings.lua (keyboard shortcuts)
│   └── utils/
│       └── helpers.lua (platform utilities)
└── plugins/
    └── tabline.lua (existing plugin)
```

## Key Decisions Made

### ✅ Accepted Approaches
1. **Modular Structure**: 4-file approach over more granular splitting
2. **Table Literal Refactoring**: Using `wezterm.merge_with` for cleaner initialization
3. **Help System**: User wants `CTRL+?` to show available keybindings
4. **Numbered Key Generation**: Function to auto-generate workspace switching keys

### ❌ Rejected Approaches
1. **Variable Names for Keybindings**: Creates unused variables in scope
2. **Over-organization**: Too many small files would be counterproductive
3. **Verbose Initialization**: Replaced with cleaner table literal patterns

## Debated Keybinding Approaches

### Mode-Based System
- **Concept**: `CTRL+s` → session mode, then single letters for actions
- **Example**: `CTRL+s` then `n` (new session), `d` (delete session), `Escape` (exit mode)
- **Pros**: Contextual keys, simpler mental model, less conflicts
- **Cons**: Requires mode switching, learning curve

### Configuration-Driven System
- **Concept**: Data structure → auto-generate keybindings + help
- **Example**: Define keys as data, generate actual bindings programmatically
- **Pros**: Data-driven, auto-generated help, template support
- **Cons**: More abstract, requires generation logic

### Hybrid Recommendation
- **Mode-based**: For complex interactions (session/window management)
- **Configuration-driven**: For simple patterns (numbered workspaces, repetitive keys)

## User Preferences & Requirements

### Must-Have Features
1. **Help System**: `CTRL+?` to display available keybindings
2. **Numbered Workspaces**: Auto-generated `CTRL+1` through `CTRL+9` for workspace switching
3. **Clean Code**: No unused variables, practical organization over theoretical
4. **Tmux Replacement**: Session management, window/pane management, persistence

### Technical Preferences
1. **Platform Awareness**: macOS primary, Linux secondary
2. **Minimal Tab/Statusbar**: User mentioned wanting more minimal setup
3. **Maintainable**: Easy to find and modify specific settings
4. **Scalable**: Ready for extensive tmux-like functionality

## Current Configuration Details

### Platform Detection
```lua
local helpers = require('utils.helpers')
-- helpers.is_macos -> boolean
-- helpers.get_os_modifier() -> 'CMD' on macOS, 'CTRL|SHIFT' elsewhere
```

### Current Keybinding Categories
- Window Management (spawn new window, edit config)
- Tab Management (create, close, navigate, numbered switching)
- Pane Management (close, split horizontal/vertical)
- Utility (reload config, copy mode)
- Advanced (F12 pop-out terminal)

### Visual Settings
- Color Scheme: Catppuccin Mocha
- Custom Colors: Mauve accents for cursor/selection
- Font: Iosevka Nerd Font (16pt, 1.5 line height)
- Window: 4px padding, macOS blur, no decorations on macOS
- Tab Bar: Bottom, transparent background, no fancy styling

## Next Steps & Roadmap

### Immediate Priorities
1. **Choose Keybinding System**: Decide between mode-based vs configuration-driven
2. **Implement Help System**: Create `CTRL+?` functionality
3. **Add Numbered Workspaces**: Implement auto-generation function

### Tmux Replacement Features
1. **Session Management**: Create, delete, rename, switch sessions
2. **Session Persistence**: Save/restore sessions across restarts
3. **Window Management**: Enhanced pane navigation and manipulation
4. **Status Bar**: Replace tabline plugin with minimal custom statusbar

### Future Enhancements
1. **Session Sharing**: Multiple clients connecting to same session
2. **Layout Management**: Save/restore window layouts
3. **Integration**: Better shell integration and status reporting

## Technical Context

### Environment
- **Primary Platform**: macOS (with blur, decorations, PATH modifications)
- **Secondary Platform**: Linux (Hyprland considerations)
- **Shell Integration**: Currently using tabline plugin (may be replaced)

### Code Patterns Established
```lua
-- Module composition pattern
local apply_appearance = require('appearance')
config = apply_appearance(config)

-- Helper function pattern
local function create_numbered_keys(modifier, action_template, start_index)
  -- Auto-generate numbered keybindings
end

-- Platform conditional pattern
if helpers.is_macos then
  -- macOS-specific settings
end
```

## Important Notes for Future Development

1. **Preserve Functionality**: All existing keybindings and settings must be maintained
2. **Modular Growth**: New features should fit into existing modular structure
3. **Help Integration**: Any new keybindings should be automatically included in help system
4. **Platform Awareness**: Consider macOS vs Linux differences in all new features
5. **User Experience**: Prioritize discoverability and ease of use over complexity

## Git Context

- **Current Branch**: `feature/wezterm-config-revamp`
- **Previous Work**: Aerospace window manager configuration merged to master
- **Commit Style**: Semantic commit messages expected
- **Testing**: WezTerm loads configuration successfully (validated)

---

*This document serves as complete context for future AI assistants working on this WezTerm configuration project. All decisions, preferences, and technical details are documented to ensure continuity and consistency.*