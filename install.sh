#!/bin/bash

# OS-Agnostic Dotfiles Installation Script
# Automatically detects OS and sets up appropriate configurations

set -e

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions
source "$DOTFILES_ROOT/lib/detect.sh"
source "$DOTFILES_ROOT/lib/symlink.sh"

print_banner() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Dotfiles Installation                     ║"
    echo "║                     OS-Agnostic Setup                        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -h, --help              Show this help message
    -o, --os OS             Force specific OS (macos, arch)
        --symlinks-only     Only create symlinks, skip package installation
        --no-symlinks       Skip symlink creation
        --dry-run           Show what would be done without making changes

Examples:
    $0                      # Auto-detect OS and install everything
    $0 --os macos           # Force macOS installation
    $0 --symlinks-only      # Only create symlinks
    $0 --dry-run            # Preview changes without applying them

EOF
}

main() {
    local forced_os=""
    local symlinks_only=false
    local no_symlinks=false
    local dry_run=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -o|--os)
                forced_os="$2"
                shift 2
                ;;
            --symlinks-only)
                symlinks_only=true
                shift
                ;;
            --no-symlinks)
                no_symlinks=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    print_banner

    # Detect or use forced OS
    local detected_os
    if [[ -n "$forced_os" ]]; then
        detected_os="$forced_os"
        log_info "Using forced OS: $detected_os"
    else
        detected_os="$(detect_os)"
        log_info "Detected OS: $detected_os"
    fi

    local architecture="$(detect_architecture)"
    log_info "Detected architecture: $architecture"

    # Validate OS support
    case "$detected_os" in
        macos|arch)
            log_success "OS supported: $detected_os"
            ;;
        *)
            log_error "Unsupported OS: $detected_os"
            log_error "Supported OS types: macos, arch"
            exit 1
            ;;
    esac

    if [[ "$dry_run" == true ]]; then
        log_warn "DRY RUN MODE - No changes will be made"
        echo
    fi

    # Check if OS-specific installer exists
    local os_installer="$DOTFILES_ROOT/os/$detected_os/install.sh"
    if [[ ! -f "$os_installer" ]]; then
        log_error "OS installer not found: $os_installer"
        exit 1
    fi

    # Run OS-specific installation (unless symlinks-only)
    if [[ "$symlinks_only" != true ]]; then
        if [[ "$dry_run" == true ]]; then
            log_info "Would run OS-specific installer: $os_installer"
        else
            log_info "Running OS-specific installer..."
            source "$os_installer"
        fi
    fi

    # Create symlinks (unless disabled)
    if [[ "$no_symlinks" != true ]]; then
        if [[ "$dry_run" == true ]]; then
            log_info "Would auto-discover and create symlinks for OS: $detected_os"
            # Show what symlinks would be created
            echo "  Bin scripts:"
            if [[ -d "$DOTFILES_ROOT/bin" ]]; then
                for script in "$DOTFILES_ROOT/bin"/*; do
                    [[ -f "$script" ]] || continue
                    local script_name="$(basename "$script")"
                    echo "    $DOTFILES_ROOT/bin/$script_name -> $HOME/.local/bin/$script_name"
                done
            fi

            echo "  Config files:"
            if [[ -d "$DOTFILES_ROOT/config/universal" ]]; then
                for config_dir in "$DOTFILES_ROOT/config/universal"/*; do
                    [[ -d "$config_dir" ]] || continue
                    local config_name="$(basename "$config_dir")"
                    echo "    $DOTFILES_ROOT/config/universal/$config_name -> $HOME/.config/$config_name"
                done
            fi

            local os_config_dir="$DOTFILES_ROOT/config/$detected_os"
            if [[ -d "$os_config_dir" ]]; then
                for config_dir in "$os_config_dir"/*; do
                    [[ -d "$config_dir" ]] || continue
                    local config_name="$(basename "$config_dir")"
                    echo "    $DOTFILES_ROOT/config/$detected_os/$config_name -> $HOME/.config/$config_name"
                done
            fi

            # Show Linux configs for Linux distros
            if [[ "$detected_os" =~ ^(arch|debian|redhat|linux)$ ]]; then
                local linux_config_dir="$DOTFILES_ROOT/config/linux"
                if [[ -d "$linux_config_dir" ]]; then
                    for config_dir in "$linux_config_dir"/*; do
                        [[ -d "$config_dir" ]] || continue
                        local config_name="$(basename "$config_dir")"
                        echo "    $DOTFILES_ROOT/config/linux/$config_name -> $HOME/.config/$config_name"
                    done
                fi
            fi
        else
            create_symlinks "$detected_os"
        fi
    fi

    if [[ "$dry_run" != true ]]; then
        echo
        log_success "Installation completed successfully!"
        echo
        log_info "Next steps:"
        echo "  • Restart your terminal or run 'exec fish' to reload fish config"
        echo "  • Configure any remaining applications manually"
        echo "  • Enjoy your new setup! 🎉"
    else
        echo
        log_info "Dry run completed. Use the command without --dry-run to apply changes."
    fi
}

# Make sure all lib scripts are executable
chmod +x "$DOTFILES_ROOT"/lib/*.sh
chmod +x "$DOTFILES_ROOT"/os/*/install.sh

# Run main function with all arguments
main "$@"
