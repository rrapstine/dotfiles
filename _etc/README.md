# _etc Directory

This directory contains system-level configuration files that should **NEVER** be symlinked to `$XDG_CONFIG_HOME`.

## Purpose

The `_etc` directory is for:
- **Systemd unit files** (mounts, services, etc.)
- **System-wide configuration files**
- **Files that need to be copied to `/etc/` or other system locations**
- **Any configuration that should not be accessible via user symlinks**

## Naming Convention

The underscore prefix (`_etc`) ensures:
1. **Always listed first** in directory listings
2. **Explicitly excluded** from symlink operations
3. **Clear visual indication** that these are special system files

## How It Works

The dotfiles system automatically skips any directory starting with `_` when:
- Creating symlinks
- Removing symlinks  
- Listing available configurations
- Checking configuration status

## Current Contents

### systemd/system/
- `media-games-setup.service` - Creates mount points for game drives
- `media-games-ssd.mount` - Mounts SSD games drive with BTRFS optimizations
- `media-games-nvme.mount` - Mounts NVMe games drive with BTRFS optimizations
- `media-games-ssd.automount` - Automount unit for SSD drive
- `media-games-nvme.automount` - Automount unit for NVMe drive

## Installation

System files in this directory are installed via the `install_systemd_mounts()` function in `lib/etc-systemd.sh`, which:
1. Copies files to appropriate system locations (`/etc/systemd/system/`)
2. Enables the systemd units
3. Starts the services
4. Tests the mounts

## Important Notes

- **NEVER** symlink anything from this directory
- **ALWAYS** use the provided installation scripts
- **REQUIRES** sudo privileges for installation
- **PERSISTS** across system reboots once installed

## Adding New System Files

When adding new system files:
1. Place them in the appropriate subdirectory under `_etc/`
2. Update the installation script in `lib/etc-systemd.sh` if needed
3. Test installation on a fresh system
4. Document the purpose in this README