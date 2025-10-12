#!/bin/bash

# macOS-specific installation script

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$DOTFILES_ROOT/lib/detect.sh"
source "$DOTFILES_ROOT/lib/package-managers.sh"
source "$DOTFILES_ROOT/lib/utils.sh"

install_macos() {
    log_info "Setting up macOS environment..."

    # Check if Xcode Command Line Tools are installed
    if ! xcode-select -p &>/dev/null; then
        log_info "Installing Xcode Command Line Tools..."
        xcode-select --install

        log_warn "Please complete the Xcode Command Line Tools installation and run this script again."
        exit 1
    else
        log_success "Xcode Command Line Tools already installed"
    fi

    # Install Homebrew packages
    install_homebrew_packages "$SCRIPT_DIR/Brewfile"

    # Ensure SSH is set up
    ensure_ssh_setup

    # Create necessary directories
    create_directories \
        "$HOME/Code" \
        "$HOME/Code/projects" \
        "$HOME/Code/scripts" \
        "$HOME/Code/templates"

    # Set fish as default shell
    if has_command fish; then
        local fish_path="/opt/homebrew/bin/fish"
        if [[ -f "$fish_path" ]]; then
            set_default_shell "$fish_path"
        fi
    fi

    # Run macOS-specific configurations
    if [[ -f "$SCRIPT_DIR/defaults.sh" ]]; then
        log_info "Applying macOS system preferences..."
        source "$SCRIPT_DIR/defaults.sh"
    fi

    # Configure dock
    if [[ -f "$SCRIPT_DIR/dock.sh" ]]; then
        log_info "Configuring dock..."
        source "$SCRIPT_DIR/dock.sh"
    fi

    log_success "macOS setup completed!"
}

# Run if called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_macos
fi
