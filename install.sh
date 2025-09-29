#!/bin/bash

# Initial Dotfiles Setup Script
# Handles first-time installation and then delegates to the dotfiles CLI

set -e

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions
source "$DOTFILES_ROOT/lib/detect.sh"

print_banner() {
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                  Dotfiles Initial Setup                     ║"
    echo "║                 First-Time Installation                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

This script handles the initial setup of your dotfiles system.
After installation, use the 'dotfiles' command for ongoing management.

Options:
    -h, --help              Show this help message
    -o, --os OS             Force specific OS (macos, arch)
        --symlinks-only     Only create symlinks, skip package installation
        --dry-run           Show what would be done without making changes

Examples:
    $0                      # Auto-detect OS and install everything
    $0 --os arch            # Force Arch Linux installation
    $0 --symlinks-only      # Only create symlinks
    $0 --dry-run            # Preview changes without applying them

After installation, use these commands:
    dotfiles install        # Install configurations
    dotfiles remove nvim    # Remove specific config
    dotfiles clean          # Clean broken symlinks
    dotfiles status         # Show current status
    dotfiles help           # Show full help

EOF
}

ensure_directories() {
    # Create necessary directories
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.config"
    
    log_info "Created necessary directories"
}

setup_cli_tool() {
    local dotfiles_script="$DOTFILES_ROOT/bin/dotfiles"
    local target="$HOME/.local/bin/dotfiles"
    
    if [[ ! -f "$dotfiles_script" ]]; then
        log_error "Dotfiles CLI script not found: $dotfiles_script"
        exit 1
    fi
    
    # Make it executable
    chmod +x "$dotfiles_script"
    
    # Create symlink if it doesn't exist or points to wrong location
    if [[ -L "$target" && "$(readlink "$target")" == "$dotfiles_script" ]]; then
        log_info "Dotfiles CLI already linked: $target"
    else
        if [[ -e "$target" ]]; then
            log_warn "Existing file at $target - backing up"
            mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        fi
        
        log_info "Creating dotfiles CLI symlink: $target -> $dotfiles_script"
        ln -sf "$dotfiles_script" "$target"
        log_success "Dotfiles CLI installed successfully!"
    fi
}

main() {
    local forced_os=""
    local symlinks_only=false
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
            --dry-run)
                dry_run=true
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                echo "Hint: After initial setup, use 'dotfiles' command for ongoing management"
                show_help
                exit 1
                ;;
        esac
    done

    print_banner

    if [[ "$dry_run" == true ]]; then
        log_warn "DRY RUN MODE - No changes will be made"
        echo
    fi

    # Setup CLI tool first
    if [[ "$dry_run" == true ]]; then
        log_info "Would setup dotfiles CLI tool in ~/.local/bin/"
    else
        ensure_directories
        setup_cli_tool
    fi

    # Build arguments for dotfiles CLI
    local dotfiles_args=("install")
    
    if [[ -n "$forced_os" ]]; then
        dotfiles_args+=("--os" "$forced_os")
    fi
    
    if [[ "$symlinks_only" == true ]]; then
        dotfiles_args+=("--symlinks-only")
    fi
    
    if [[ "$dry_run" == true ]]; then
        dotfiles_args+=("--dry-run")
    fi

    echo
    log_info "Delegating to dotfiles CLI for installation..."
    echo

    # Run the dotfiles CLI
    if [[ "$dry_run" == true ]]; then
        log_info "Would run: dotfiles ${dotfiles_args[*]}"
        # Still show what the CLI would do
        "$DOTFILES_ROOT/bin/dotfiles" "${dotfiles_args[@]}" 2>/dev/null || true
    else
        "$DOTFILES_ROOT/bin/dotfiles" "${dotfiles_args[@]}"
        
        echo
        log_success "Setup completed successfully!"
        echo
        log_info "The 'dotfiles' command is now available for ongoing management:"
        echo "  • dotfiles status       # Show current symlink status"
        echo "  • dotfiles remove nvim  # Remove specific config"
        echo "  • dotfiles clean        # Clean broken symlinks"
        echo "  • dotfiles help         # Show all available commands"
        echo
        log_info "Restart your terminal or run 'exec \$SHELL' to use the dotfiles command"
    fi
}

# Make sure all scripts are executable
chmod +x "$DOTFILES_ROOT"/lib/*.sh
chmod +x "$DOTFILES_ROOT"/os/*/install.sh
chmod +x "$DOTFILES_ROOT"/bin/*

# Run main function with all arguments
main "$@"
