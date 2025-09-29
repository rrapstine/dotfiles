# OS-Agnostic Dotfiles

This repository contains my cross-platform dotfiles setup that works seamlessly across macOS and Arch Linux. It features a comprehensive CLI tool for managing configurations, with automatic OS detection and intelligent symlink management.

## ✨ Features

- **🔍 Automatic OS Detection**: Detects macOS and Arch Linux automatically
- **📦 Modular Package Management**: OS-specific package installation (Homebrew for macOS, pacman/AUR for Arch)
- **🔗 Smart Symlinking**: Automatic symlink discovery and management based on directory structure
- **⚙️ Organized Configuration**: Universal, OS-specific, and Linux-specific configurations
- **🛠️ Extensible CLI**: Comprehensive `dotfiles` command with subcommands for all operations
- **🎯 Selective Installation**: Install individual configurations or everything at once
- **⚠️ OS Mismatch Detection**: Smart warnings when installing OS-specific configs on different platforms
- **🎯 Quick Editing**: Built-in editor integration for rapid config modifications
- **🧹 Maintenance Tools**: Clean broken symlinks, remove configurations, status reporting
- **🚀 One Command Setup**: Single command installation with multiple options

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rrapstine/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the initial setup:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Use the dotfiles CLI for ongoing management:**
   ```bash
   dotfiles status    # Check current setup
   dotfiles edit nvim # Edit configurations
   dotfiles help      # See all commands
   ```

The initial setup will:
- Detect your OS automatically
- Install the `dotfiles` CLI tool
- Install OS-specific packages
- Create symlinks for all available configurations
- Set up your development environment

## 🛠️ CLI Commands

After initial setup, use the `dotfiles` command for all operations:

### Core Commands
```bash
# Installation & Setup
dotfiles install                    # Full installation (all configurations)
dotfiles install hypr               # Install only hypr configuration
dotfiles install nvim               # Install only nvim configuration
dotfiles install fish --os arch     # Install fish with forced OS
dotfiles install --os arch          # Force specific OS for full install
dotfiles install --symlinks-only    # Only create symlinks (skip packages)
dotfiles install --dry-run          # Preview changes

# Configuration Management
dotfiles edit                       # Open dotfiles directory in $EDITOR
dotfiles edit nvim                  # Edit specific config (nvim, fish, etc.)
dotfiles edit hypr                  # Edit hyprland config
dotfiles remove nvim                # Remove specific config symlinks
dotfiles remove all                 # Remove all dotfiles symlinks

# Maintenance & Information
dotfiles status                     # Show current symlink status
dotfiles list                       # Show available configurations
dotfiles clean                      # Remove broken symlinks
dotfiles help [command]             # Show help for specific command
```

### Initial Setup Options
The `install.sh` script supports these options for first-time setup:

```bash
./install.sh                       # Auto-detect OS and install everything
./install.sh --os arch              # Force Arch Linux installation
./install.sh --symlinks-only        # Only create symlinks
./install.sh --dry-run              # Preview changes
```

## 📁 Directory Structure

The dotfiles are organized into several categories:

```
dotfiles/
├── bin/                    # Executable scripts (symlinked to ~/.local/bin/)
├── config/
│   ├── universal/          # Cross-platform configurations
│   ├── linux/              # Linux-specific configurations
│   └── [os]/               # OS-specific configurations (macos, arch)
├── os/                     # OS-specific installation scripts
└── lib/                    # Utility functions
```

### Configuration Categories

- **Universal**: Configs that work across all platforms (fish, nvim, git, etc.)
- **Linux**: Configs specific to Linux distributions (hyprland, waybar, etc.)
- **OS-specific**: Configs for specific operating systems

## 🔧 Customization

### Adding New Applications

1. **Add the application config** to the appropriate directory:
   - `config/universal/` for cross-platform apps
   - `config/linux/` for Linux-specific apps
   - `config/macos/` or `config/arch/` for OS-specific apps

2. **Add packages** to OS-specific package files:
   - macOS: `os/macos/Brewfile`
   - Arch: `os/arch/packages.txt`

3. **The symlinks are created automatically** based on directory structure - no manual configuration needed!

4. **Test your new config** with selective installation:
   ```bash
   dotfiles install myapp --dry-run    # Preview the installation
   dotfiles install myapp              # Install just your new config
   ```

### Adding New Operating Systems

1. Create a new directory in `os/` (e.g., `os/ubuntu/`)
2. Add an `install.sh` script for that OS
3. Create package files specific to that OS
4. Add OS detection logic to `lib/detect.sh`
5. Optionally add OS-specific configs in `config/ubuntu/`

The symlink system will automatically discover and link configurations!

## 🎯 Key Features in Detail

### Selective Installation
Install specific configurations instead of everything at once:

```bash
# Install individual configurations
dotfiles install hypr               # Hyprland window manager
dotfiles install fish               # Fish shell only
dotfiles install nvim               # Neovim configuration
dotfiles install waybar             # Waybar status bar

# Cross-platform safety
dotfiles install hypr --os macos    # Warns: hypr is for Linux, you're on macOS
                                    # Prompts: "Are you sure? (y/N)"

# Combine with other options
dotfiles install nvim --dry-run     # Preview nvim installation
dotfiles install fish --symlinks-only  # Install fish symlinks only
```

**Features:**
- **Intelligent Discovery**: Automatically finds configs in universal, OS-specific, and Linux directories
- **OS Validation**: Warns when installing OS-specific configs on incompatible systems
- **Interactive Prompts**: Asks for confirmation on potential mismatches
- **Error Handling**: Clear messages for non-existent configurations with available options
- **Backward Compatible**: Original `dotfiles install` (install everything) still works

### Smart Editor Integration
```bash
dotfiles edit                       # Open entire dotfiles in $EDITOR
dotfiles edit nvim                  # Open nvim config specifically
dotfiles edit hypr                  # Open hyprland config
```
- Requires `$EDITOR` environment variable
- Automatically finds configs across all directories
- Interactive selection when multiple matches exist

### Intelligent Symlink Management
- **Automatic discovery**: No manual configuration needed
- **Conflict resolution**: Existing files backed up with timestamps
- **Broken link cleanup**: `dotfiles clean` removes orphaned symlinks
- **Selective removal**: Remove individual configs or all at once

### Status and Information
```bash
dotfiles status                     # See what's currently linked
dotfiles list                       # See all available configurations
```

## 🐛 Troubleshooting

### Common Issues

**Missing $EDITOR**: Set your preferred editor:
```bash
export EDITOR=nvim                  # Add to your shell profile
```

**Permission Errors**: The installer automatically makes scripts executable, but if needed:
```bash
chmod +x install.sh bin/* lib/*.sh os/*/install.sh
```

**Symlink Conflicts**: Existing files are automatically backed up to `~/.config/_backups/`

**Broken Symlinks**: Clean them up easily:
```bash
dotfiles clean                      # Remove all broken symlinks
```

### Installation Scenarios

**Installing Linux configs on macOS/other OS:**
- The system will warn you and ask for confirmation
- This allows for testing configs or manual cross-platform setups
- Example: Installing waybar on macOS won't work but won't break anything

**Configuration not found:**
- Use `dotfiles list` to see all available configurations
- Check spelling and try again
- Use `dotfiles help install` for usage examples

**Multiple arguments:**
- Only one configuration name is allowed per install command
- Run multiple commands for multiple configs: `dotfiles install nvim && dotfiles install fish`

### Getting Help

If you encounter issues:
1. Use `dotfiles status` to see current state
2. Run `dotfiles install --dry-run` to preview changes
3. Use `dotfiles list` to see available configurations
4. Check `dotfiles help [command]` for specific command help
5. Ensure your OS is supported (macOS or Arch Linux)
6. Verify internet connectivity for package downloads

## 📝 Creating Your Own Dotfiles

To create your own version:

1. **Fork this repository**
2. **Customize the configurations** in the `config/` directory
3. **Update package lists** in `os/*/` directories  
4. **Add your own bin scripts** in the `bin/` directory
5. **Adjust OS-specific installation scripts** as needed

The modular structure and automatic discovery system make it easy to add, remove, or modify components without affecting the core functionality.

### Available Configurations

This dotfiles setup currently includes:

**Universal (Cross-platform):**
- Fish shell with plugins and themes
- Neovim with comprehensive Lua configuration
- Git configuration and global gitignore
- Kitty terminal emulator
- Tmux with plugin management
- Wezterm terminal
- Ghostty terminal

**Linux-specific:**
- Hyprland wayland compositor with full configuration
- Waybar status bar with custom modules
- Wofi application launcher
- Wlogout logout menu
- OpenRazer and Polychromatic for Razer peripherals

**Utility Scripts:**
- `ec`: Edit configurations quickly
- `tp`: Project navigation tool
- `setup`: Environment setup utilities

## Thanks To...

I first got the idea for starting this project by visiting the [GitHub does dotfiles](https://dotfiles.github.io/) project. Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration. Also, I'd like to thank [Emma Fabre](https://twitter.com/anahkiasen) for [her excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin) which made me migrate a lot to a [`Brewfile`](./Brewfile) and [Mackup](https://github.com/lra/mackup).

In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
