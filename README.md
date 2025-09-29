# OS-Agnostic Dotfiles

This repository contains my cross-platform dotfiles setup that works seamlessly across macOS and Arch Linux. It automatically detects my operating system and installs the appropriate packages and configurations, while providing a GNU stow-like symlink management system.

## ✨ Features

- **🔍 Automatic OS Detection**: Detects macOS and Arch Linux automatically
- **📦 Modular Package Management**: OS-specific package installation (Homebrew for macOS, pacman/AUR for Arch)
- **🔗 Smart Symlinking**: GNU stow-like symlink management based on OS profiles
- **⚙️ Organized Configuration**: Configs are either universal or OS-specific
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
   sudo chmod +x install.sh
   ./install.sh
   ```

That's it! The installer will:
- Detect the OS automatically
- Install the listed packages
- Create symlinks for available configurations
- Set OS environment variables (MacOS only)

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
3. **Add packages** to the OS-specific package files (`os/macos/Brewfile` or `os/arch/packages.txt`)
2. **Update the profile files** (`profiles/macos.conf` or `profiles/arch.conf`) to include symlink mappings (optional)

### Adding New Operating Systems

1. Create a new directory in `os/` (e.g., `os/ubuntu/`)
2. Add an `install.sh` script for that OS
3. Create package files specific to that OS
4. Add OS detection logic to `lib/detect.sh`
5. Create a profile file in `profiles/`

### Profile Configuration Format

In the event that automatic detection will not work for your environment, you can create OS specific profiles which direct the script where to place your configs and scripts.
Profiles use a simple `source=target` format:

```bash
# Example: profiles/macos.conf
fish/config.fish=$HOME/.config/fish/config.fish
config/kitty/kitty.conf=$HOME/.config/kitty/kitty.conf
bin/ec=$HOME/.local/bin/ec
```

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

## 📝 Creating Your Own Dotfiles

To create your own version:

1. **Fork this repository**
2. **Customize the configurations** in the `config/` directory
3. **Update package lists** in `os/*/` directories
4. **Modify profiles** in `profiles/` to match your setup
5. **Adjust OS-specific scripts** as needed

The modular structure makes it easy to add, remove, or modify components without affecting the core functionality.

## Thanks To...

I first got the idea for starting this project by visiting the [GitHub does dotfiles](https://dotfiles.github.io/) project. Both [Zach Holman](https://github.com/holman/dotfiles) and [Mathias Bynens](https://github.com/mathiasbynens/dotfiles) were great sources of inspiration. Also, I'd like to thank [Emma Fabre](https://twitter.com/anahkiasen) for [her excellent presentation on Homebrew](https://speakerdeck.com/anahkiasen/a-storm-homebrewin) which made me migrate a lot to a [`Brewfile`](./Brewfile) and [Mackup](https://github.com/lra/mackup).

In general, I'd like to thank every single one who open-sources their dotfiles for their effort to contribute something to the open-source community.
