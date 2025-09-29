# OS-Agnostic Dotfiles

This repository contains my cross-platform dotfiles setup that works seamlessly across macOS and Arch Linux. It automatically detects your operating system and installs the appropriate packages and configurations, while providing a GNU stow-like symlink management system.

## ✨ Features

- **🔍 Automatic OS Detection**: Detects macOS and Arch Linux automatically
- **📦 Modular Package Management**: OS-specific package installation (Homebrew for macOS, pacman/AUR for Arch)
- **🔗 Smart Symlinking**: GNU stow-like symlink management based on OS profiles
- **⚙️ Organized Configuration**: Configs organized by application, not OS
- **🛠️ Extensible**: Easy to add support for new operating systems
- **🚀 One Command Setup**: Single command installation with multiple options

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/rrapstine/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. **Run the installer:**
   ```bash
   ./install.sh
   ```

That's it! The installer will:
- Detect your OS automatically
- Install the appropriate packages
- Create symlinks for your configurations
- Set up your development environment

## 📁 Repository Structure

```
dotfiles/
├── install.sh              # Main installation script
├── lib/                    # Utility libraries
│   ├── detect.sh          # OS/architecture detection
│   ├── package-managers.sh # Package manager abstractions
│   ├── symlink.sh         # Symlink management
│   └── utils.sh           # Common utilities
├── os/                     # OS-specific configurations
│   ├── macos/             # macOS specific files
│   │   ├── install.sh     # macOS installation script
│   │   ├── Brewfile       # Homebrew packages
│   │   ├── defaults.sh    # macOS system preferences
│   │   └── dock.sh        # Dock configuration
│   └── arch/              # Arch Linux specific files
│       ├── install.sh     # Arch installation script
│       ├── packages.txt   # pacman/AUR packages
│       └── services.txt   # systemd services
├── config/                 # Application configurations
│   ├── shell/             # Shell configs (zsh, fish)
│   ├── terminal/          # Terminal emulators
│   ├── editor/            # Editor configurations
│   ├── tmux/              # Tmux configuration
│   └── desktop/           # Desktop environment configs
│       ├── macos/         # macOS specific (Aerospace, etc.)
│       └── linux/         # Linux WM configs (Hyprland, etc.)
└── profiles/               # OS-specific symlink profiles
    ├── macos.conf         # macOS symlink mappings
    └── arch.conf          # Arch Linux symlink mappings
```

## 🛠️ Installation Options

The installer supports several options for different use cases:

```bash
# Basic installation (auto-detects OS)
./install.sh

# Force specific OS
./install.sh --os macos
./install.sh --os arch

# Only create symlinks (skip package installation)
./install.sh --symlinks-only

# Skip symlink creation
./install.sh --no-symlinks

# Preview what would be done
./install.sh --dry-run

# Show help
./install.sh --help
```

## 🔧 Customization

### Adding New Applications

1. **Add the application config** to the appropriate directory in `config/`
2. **Update the profile files** (`profiles/macos.conf` or `profiles/arch.conf`) to include symlink mappings
3. **Add packages** to the OS-specific package files (`os/macos/Brewfile` or `os/arch/packages.txt`)

### Adding New Operating Systems

1. Create a new directory in `os/` (e.g., `os/ubuntu/`)
2. Add an `install.sh` script for that OS
3. Create package files specific to that OS
4. Add OS detection logic to `lib/detect.sh`
5. Create a profile file in `profiles/`

### Profile Configuration Format

Profiles use a simple `source=target` format:

```bash
# Example: profiles/macos.conf
fish/config.fish=$HOME/.config/fish/config.fish
config/terminal/kitty/kitty.conf=$HOME/.config/kitty/kitty.conf
bin/ec=$HOME/.local/bin/ec
```

## 🎯 Supported Applications

The dotfiles currently support configurations for:

- **Shells**: Zsh, Fish
- **Terminals**: Kitty, WezTerm
- **Editors**: Neovim
- **Multiplexers**: Tmux
- **Development**: Git, various programming languages
- **Desktop (macOS)**: Aerospace, SketchyBar, Dock
- **Desktop (Linux)**: Hyprland, Waybar, Wofi (configurable)

## 🐛 Troubleshooting

### Common Issues

**SSH Key Issues**: If you encounter SSH authentication problems, the installer will guide you through setting up a new SSH key for GitHub.

**Permission Errors**: Make sure all scripts are executable:
```bash
chmod +x install.sh lib/*.sh os/*/install.sh
```

**Symlink Conflicts**: Existing files will be backed up with a timestamp before creating symlinks.

### Getting Help

If you encounter issues:
1. Run with `--dry-run` first to see what would happen
2. Check the logs for specific error messages
3. Ensure your OS is supported (macOS or Arch Linux)
4. Make sure you have internet connectivity for package downloads

## 🤝 Contributing

Feel free to contribute by:
- Adding support for new operating systems
- Improving existing configurations
- Fixing bugs or adding features
- Updating documentation

## 📝 Creating Your Own Dotfiles

To create your own version:

1. **Fork this repository**
2. **Customize the configurations** in the `config/` directory
3. **Update package lists** in `os/*/` directories
4. **Modify profiles** in `profiles/` to match your setup
5. **Adjust OS-specific scripts** as needed

The modular structure makes it easy to add, remove, or modify components without affecting the core functionality.

## Thanks To...

I first got the idea for starting this project by visiting the [GitHub does dotfiles](https://dotfiles.github.io/) project. Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration. [Sourabh Bajaj](https://twitter.com/sb2nov/)'s [Mac OS X Setup Guide](http://sourabhbajaj.com/mac-setup/) proved to be invaluable. Thanks to [@subnixr](https://github.com/subnixr) for [his awesome Zsh theme](https://github.com/subnixr/minimal)! Thanks to [Caneco](https://twitter.com/caneco) for the header in this readme. And lastly, I'd like to thank [Emma Fabre](https://twitter.com/anahkiasen) for [her excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin) which made me migrate a lot to a [`Brewfile`](./Brewfile) and [Mackup](https://github.com/lra/mackup).

In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
